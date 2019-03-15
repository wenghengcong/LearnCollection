/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Topic and note local cache class, managing the local cache for topics and notes.
 */

import Foundation
import CloudKit

// "container", "database", and "zone" are immutalbe; "topics" and "serverChangeToken" are mutable,
// thus "topic.permission", "topic.notes", "topic.record", "note.permission", "note.record" are mutable.
//
// TopicLocalCache and subclasses follow these rules to be thread-safe:
// 1. Public methods access mutable properties via "perform...".
// 2. Private methods that access mutable properties should be called via "perform...".
// 3. Private methods access mutable properties directly because of #2
// 4. Immutable properties are accessed directly.
//
// We don't provide accessors to protect mutable properties because we don't want to call "perform..."
// in every call to the properties. Clients should wrap the code accessing mutable properties
// directly with "perform...".
//
// Clients follow these rules to thread-safely use BaseLocalCache or its subclasses:
// 1. Access mutable properties via "perform...".
// 2. Call public methods directly, otherwise will trigger a deadlock.
//
final class TopicLocalCache: BaseLocalCache {

    let container: CKContainer
    let database: CKDatabase
    let zone: CKRecordZone
    
    private var serverChangeToken: CKServerChangeToken?
    var topics = [Topic]()
    
    init(container: CKContainer, database: CKDatabase, zone: CKRecordZone) {
        
        self.container = container
        self.database = database
        self.zone = zone
        
        super.init()
        
        fetchChanges() // Fetching changes with nil token to build up the cache.
    }

    private func sortTopics() {
        
        topics.sort { topic0, topic1 in
            guard let name0 = topic0.record[Schema.Topic.name] as? String,
                let name1 = topic1.record[Schema.Topic.name] as? String else { return false }
            return name0 < name1
        }
    }
    
    // Remove the deleted reocrds from the cached. Topic records are handled first.
    // If a topic record is removed, the notes of the topic will be removed as well.
    //
    private func updateWithRecordIDsDeleted(_ recordIDsDeleted: [CKRecordID]) {
        
        var noteIDsDeleted = [CKRecordID]()
        
        for recordID in recordIDsDeleted {
        
            if let index = topics.index(where: { $0.record.recordID == recordID }) {
                topics.remove(at: index)
            } else {
                noteIDsDeleted.append(recordID)
            }
        }
        
        noteIDLoop: for recordID in noteIDsDeleted {
            
            for topic in topics {
                if let index = topic.notes.index(where: { $0.record.recordID == recordID }) {
                    topic.notes.remove(at: index)
                    continue noteIDLoop
                }
            }
            // else: notes that doesn't belong to a topic, which should have been removed.
        }
    }
        
    // Process the changed topics. The records not found in the existing cache are new.
    // There are several things to consider:
    // 1. For a new sharing topic:
    // the root record and the share record will both in withRecordsChanged, so we can retrieve the
    // permission from the share record.
    //
    // 2. For a note:
    // a. It is shared because its parent is shared, thus no share record is created and
    // no share record in withRecordsChanged. The permission should be the same as the parent.
    // b. If it is shared independently, so a new share record is created, and is in withRecordsChanged.
    //
    // 3. For a permission change:
    // Only the associated share record is changed, and in withRecordsChanged. So we have to go through
    // the local cache to update the permission.
    //
    private func updateWithRecordsChanged(_ recordsChanged: [CKRecord]) {
        
        // We can make a mutable copy of withRecordsChanged and remove the processed items in the loop
        // That however isn't necessarily better given withRecordsChanged won't be a big array,so simply
        // use the immutable one and go through every items every time.
        //
        // We only care CKShare and CKSharePermission when we are currently in sharedDB.
        //
        let isSharedDB = database.databaseScope == .shared ? true : false

        // Gather the share records first, only for sharedDB.
        //
        var sharesChanged = [CKShare]()
        if isSharedDB {
            for record in recordsChanged where record is CKShare {
                sharesChanged.append(record as! CKShare)
            }
        }
        
        // True if there are changed topics so we need to sort the topics later.
        // Topics can be many, so make sure we don't sort it unnecessarily.
        //
        var isTopicNameChanged = false
        for record in recordsChanged where record.recordType == Schema.RecordType.topic {
  
            var topicChanged: Topic
            if let index = topics.index(where: { $0.record.recordID == record.recordID }) {
                
                topicChanged = topics[index]
                if let oldName = topicChanged.record[Schema.Topic.name] as? String,
                    let newName = record[Schema.Topic.name] as? String, oldName != newName {
                    isTopicNameChanged = true // Topic name is changed, so sort the topics later.
                }
                topicChanged.record = record
                
            } else {
                
                isTopicNameChanged = true // At least one new topic, so sort the topic later.
                topicChanged = Topic(topicRecord: record)
                topics.append(topicChanged)
            }
            
            // Set permission with the gathered share records if matched.
            // Remove the processed share from sharesChanged. Only do this for sharedDB.
            //
            if isSharedDB, !sharesChanged.isEmpty, let index = topicChanged.setPermission(with: sharesChanged) {
                sharesChanged.remove(at: index)
            }
        }
        if isTopicNameChanged { sortTopics() } // Sort the topics by name if topics are changed.
        
        // Now process the changed notes.
        //
        var unsortedTopicIndice = [Int]()
        for record in recordsChanged where record.recordType == Schema.RecordType.note {
            
            var noteChanged: Note, isNoteNameChanged = false
            var topicOrNil: Topic?, topicIndexOrNil: Int?
            
            if let topicRef = record[Schema.Note.topic] as? CKReference {
                
                if let index = topics.index(where: { $0.record.recordID == topicRef.recordID }) {
                    topicOrNil = topics[index]
                    topicIndexOrNil = index
                }
            }
            
            guard let topic = topicOrNil, let topicIndex = topicIndexOrNil else {
                fatalError("Failed to find the topic for a changed note!")
            }
            
            if let noteIndex = topic.notes.index(where: { $0.record.recordID == record.recordID }) {
                
                noteChanged = topic.notes[noteIndex]
                
                if let oldTitle = noteChanged.record[Schema.Note.title] as? String,
                    let newTitle = record[Schema.Note.title] as? String, oldTitle != newTitle {
                    isNoteNameChanged = true // Name is changed, so sort notes later.
                }
                
                noteChanged.record = record
                
            } else {
                
                noteChanged = Note(noteRecord: record)
                if isSharedDB { // Default to parent permission if it is a sharedDB record.
                    noteChanged.permission = topic.permission
                }
                topic.notes.append(noteChanged)
                
                isNoteNameChanged = true // New note, so sort the notes later.
            }

            // Manage the sorted status if the note name is changed.
            //
            if isNoteNameChanged {
                if unsortedTopicIndice.index(where: { $0 == topicIndex }) == nil {
                    unsortedTopicIndice.append(topicIndex)
                }
            }
        }
        
        // Sort the notes array of changed Topics.
        //
        for index in unsortedTopicIndice { topics[index].sortNotes() }
        
        guard isSharedDB, !sharesChanged.isEmpty else { return }
        
        // Now there are some share records that are changed but not processed. This happens when useres changed
        // the share options, which only affects the share record, not the root record.
        // In that case, we have to go through the whole TopicLocalCache to find the right item and upate its permission.
        //
        for var topic in topics {
            _ = topic.setPermission(with: sharesChanged)
        }
    }
    
    // Update the cache by fetching the database changes.
    // Note that fetching changes is only supported in custom zones.
    //
    func fetchChanges() {
        
        // Use NSMutableDictionary, rather than Swift dictionary
        // because this may be changed in the completion handler.
        //
        var recordsChanged = [CKRecord](), recordIDsDeleted = [CKRecordID]()
        let notificationObject = TopicCacheDidChange()

        let options = CKFetchRecordZoneChangesOptions()
        performWriterBlock { options.previousServerChangeToken = self.serverChangeToken }
        
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [zone.zoneID],
                                                          optionsByRecordZoneID: [zone.zoneID: options])
        
        // Gather the changed records for processing in a batch.
        //
        operation.recordChangedBlock = { record in
            recordsChanged.append(record)
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordID, _) in
            recordIDsDeleted.append(recordID)
        }

        operation.recordZoneChangeTokensUpdatedBlock = { (zoneID, serverChangeToken, _) in
            assert(zoneID == self.zone.zoneID)
            self.performWriterBlock { self.serverChangeToken = serverChangeToken }
        }

        operation.recordZoneFetchCompletionBlock = {
            (zoneID, serverChangeToken, clientChangeTokenData, moreComing, error) in
            
            // Fetch changes again with nil token if the token has expired.
            // .zoneNotfound error is handled in fetchRecordZoneChangesCompletionBlock as a partial error.
            //
            if let ckError = handleCloudKitError(error, operation: .fetchChanges),
                ckError.code == .changeTokenExpired {
                
                self.performWriterBlock { self.serverChangeToken = nil }
                self.fetchChanges()
                return
            }
            assert(zoneID == self.zone.zoneID && moreComing == false)
            self.performWriterBlock { self.serverChangeToken = serverChangeToken }
        }

        operation.fetchRecordZoneChangesCompletionBlock = { error in
            
            // TopicLocalCache.fetchChanges is always triggered by database subscriotion,
            // so the zone was deleted by a peer, this fetchRecordZoneChangesOpetion should not happen.
            // However, .zoneNotFound can happens when a participant removes self from a share and the
            // share is the only item in the current zone. In that case,
            // cloudSharingControllerDidStopSharing should delete the cached zone, thus
            // triggers a zone switching. So the error can be ignored.
            //
            if let ckError = handleCloudKitError(error, operation: .fetchChanges,
                                                 affectedObjects: [self.zone.zoneID]) {
                print("Error in fetchRecordZoneChangesCompletionBlock: \(ckError)")
            }
            
            // The IDs in recordsChanged can be in recordIDsDeleted, meaning a changed record can be deleted,
            // So filter out the updated but deleted IDs.
            //
            recordsChanged = recordsChanged.filter { record in
                return !recordIDsDeleted.contains(record.recordID)
            }
            
            // Push recordIDsDeleted and recordsChanged into notification payload.
            //
            notificationObject.payload = TopicCacheChanges(recordIDsDeleted: recordIDsDeleted,
                                                           recordsChanged: recordsChanged)
            
            self.performWriterBlock { // Do the update.
                self.updateWithRecordIDsDeleted(recordIDsDeleted)
                self.updateWithRecordsChanged(recordsChanged)
            }
            print("\(#function):Deleted \(recordIDsDeleted.count); Changed \(recordsChanged.count)")
        }
        operation.database = database
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .topicCacheDidChange, object: notificationObject)
    }
    
    // Convenient method for updating the cache with one specified record ID.
    //
    func updateWithRecordID(_ recordID: CKRecordID) {
        
        let fetchRecordsOp = CKFetchRecordsOperation(recordIDs: [recordID])
        fetchRecordsOp.fetchRecordsCompletionBlock = {recordsByRecordID, error in
            
            guard handleCloudKitError(error, operation: .fetchRecords, affectedObjects: [recordID]) == nil,
                let record = recordsByRecordID?[recordID]  else { return }
            
            self.performWriterBlock { self.updateWithRecordsChanged([record]) }
        }
        fetchRecordsOp.database = database
        operationQueue.addOperation(fetchRecordsOp)
        postWhenOperationQueueClear(name: .topicCacheDidChange)
    }
}

// Convenient methods for the database editing, called by view controllers to update the database.
//
extension TopicLocalCache { // MARK: - Add / Delete a topic or note
    
    func addTopic(with name: String) {
        
        let newRecord = CKRecord(recordType: Schema.RecordType.topic, zoneID: zone.zoneID)
        newRecord[Schema.Topic.name] = name as CKRecordValue?
    
        let operation = CKModifyRecordsOperation(recordsToSave: [newRecord], recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            guard handleCloudKitError(error, operation: .modifyRecords, alert: true) == nil,
                let newRecord = records?[0] else { return }
            
            self.performWriterBlock {
                let topic = Topic(topicRecord: newRecord) // New Topic so no need to fetch its notes
                self.topics.append(topic)
                self.sortTopics()
            }
        }
        operation.database = database
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .topicCacheDidChange)
    }
    
    func deleteTopic(_ topic: Topic) {
        
        let recordID = performReaderBlockAndWait { return topic.record.recordID }
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordID])
        
        operation.modifyRecordsCompletionBlock = { (_, _, error) in
            guard handleCloudKitError(error, operation: .modifyRecords, alert: true) == nil else { return }
            
            self.performWriterBlock {
                if let index = self.topics.index(where: { $0.record.recordID == topic.record.recordID }) {
                    self.topics.remove(at: index)
                }
            }
        }
        operation.database = database
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .topicCacheDidChange)
    }
    
    func addNote(_ note: Note, topic: Topic) {
        
        let noteRecord = performReaderBlockAndWait { return note.record }
        let operation = CKModifyRecordsOperation(recordsToSave: [noteRecord], recordIDsToDelete: nil)
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) in
            
            guard handleCloudKitError(error, operation: .modifyRecords, alert: true) == nil,
                let savedRecord = records?[0] else { return }
            
            self.performWriterBlock {
                if topic.notes.index(where: { $0.record.recordID == savedRecord.recordID }) == nil {
                    topic.notes.append(Note(noteRecord:savedRecord))
                }
                topic.sortNotes()
            }
        }
        operation.database = database
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .topicCacheDidChange)
    }
    
    func deleteNote(_ note: Note, topic: Topic) {
        
        let recordID = performReaderBlockAndWait { return note.record.recordID }
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordID])
        
        operation.modifyRecordsCompletionBlock = { (_, _, error) in
            guard handleCloudKitError(error, operation: .modifyRecords, alert: true) == nil else { return }
            
            self.performWriterBlock {
                if let index = topic.notes.index(where: { $0.record.recordID == note.record.recordID }) {
                    topic.notes.remove(at: index)
                }
            }
        }
        operation.database = database
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .topicCacheDidChange)
    }
}

// Convenient methods to delete a record from the cache, without updating the server side.
// This is needed in cloudSharingControllerDidStopSharing, called when the user stops a share.
//
extension TopicLocalCache { // MARK: - Delete Cached Record
    
    private func deleteCachedTopic(_ record: CKRecord) {
        
        if let index = self.topics.index(where: { $0.record.recordID == record.recordID }) {
            self.topics.remove(at: index)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .topicCacheDidChange, object: nil)
            }
        }
    }
    
    private func deleteCachedNote(_ record: CKRecord) {
        
        var topicOptional: Topic?
        
        if let topicRef = record[Schema.Note.topic] as? CKReference {
            if let index = self.topics.index(where: { $0.record.recordID == topicRef.recordID }) {
                topicOptional = self.topics[index]
            }
        }
        
        if let topic = topicOptional,
            let index = topic.notes.index(where: { $0.record.recordID == record.recordID }) {
            topic.notes.remove(at: index)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .topicCacheDidChange, object: nil)
            }
        }
    }
    
    func deleteCachedRecord(_ record: CKRecord) {
        
        self.performWriterBlock {
            if record.recordType == Schema.RecordType.topic {
                self.deleteCachedTopic(record)
                
            } else if record.recordType == Schema.RecordType.note {
                self.deleteCachedNote(record)
            }
        }
    }
}
