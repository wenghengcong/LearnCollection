/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Modal classes and protocol for local cache items.
 */

import Foundation
import CloudKit

// Permission control in UI.
// In the private database, permission is default to .readWrite for the record creator.
// shareDB is different:
// 1. A participant can always remove the participation by presentign a UICloudSharingController
// 2. A participant can change the record content if they have .readWrite permission.
// 3. A participant can add a record into a parent if they have .readWrite permission.
// 4. A participant can remove a record added by themselves from a parent.
// 5. A participant can not remove a root record if they are not the creator.
// 6. Users can not "add" a note if they can't write the topic. (Implemented in MainViewController.numberOfRowsInSection)
//

protocol CacheItem {
    var record: CKRecord { get set }
    var permission: CKShareParticipantPermission { get set }
}

extension CacheItem {
    mutating func setPermission(with shares: [CKShare]) -> Int? {
        for (index, share) in shares.enumerated() where record.share?.recordID == share.recordID {
            if let participant = share.currentUserParticipant {
                permission = participant.permission
                return index
            }
        }
        return nil
    }
}

// Note: Data modal class.
// Use "final" as we provide a default implementation via a protocol extension.
//
final class Note: CacheItem {
    var record: CKRecord
    var permission = CKShareParticipantPermission.readWrite
    
    init(noteRecord: CKRecord) {
        record = noteRecord
    }
}

// Topic: Data modal class.
// Use "final" as we provide a default implementation via a protocol extension.
//
final class Topic: CacheItem {
    var record: CKRecord
    var permission = CKShareParticipantPermission.readWrite
    var notes: [Note]
    
    init(topicRecord: CKRecord, notes: [Note] = [Note]()) {
        record = topicRecord
        self.notes = notes
    }
    
    func sortNotes() {
        notes.sort {
            let title0 = ($0.record[Schema.Note.title] as? String) ?? ""
            let title1 = ($1.record[Schema.Note.title] as? String) ?? ""
            return title0 < title1
        }
    }
}
