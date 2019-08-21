/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller class for managing topics and notes.
 */

import UIKit
import CloudKit

final class MainViewController: SpinnerViewController, UICloudSharingControllerDelegate {
    
    // Clients should set this before presenting UICloudSharingController
    // so that delegate method can access info in the root record.
    //
    private var rootRecord: CKRecord?
    
    private var zoneCacheOrNil: ZoneLocalCache? {
        return (UIApplication.shared.delegate as? AppDelegate)?.zoneCacheOrNil
    }
    private var topicCacheOrNil: TopicLocalCache? {
        return (UIApplication.shared.delegate as? AppDelegate)?.topicCacheOrNil
    }
    
    // Start spinner animation in viewDidLoad because
    // TopicCacheDidChange should come soon, which will stop the animation
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of:self).topicCacheDidChange(_:)),
            name: NSNotification.Name.topicCacheDidChange, object: nil)
        spinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let topicCache = topicCacheOrNil else { return }
        title = topicCache.database.name + "." + topicCache.zone.zoneID.zoneName
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let topicCache = topicCacheOrNil else { fatalError("\(#function): topicCache shouldn't be nil!") }

        guard let noteNC = segue.destination as? UINavigationController,
            let noteViewController = noteNC.topViewController as? NoteViewController else { return }
        
        // 'sender' should be the current topic under which the note is added
        //
        guard let identifier = segue.identifier, identifier == SegueID.mainAddNew else { return }
        guard let topic = sender as? Topic else { return }

        // Create a new note record.
        // Set up parent so that if the whole hierarchy is shared if the topic is shared.
        //
        let noteRecord = CKRecord(recordType: Schema.RecordType.note, zoneID: topicCache.zone.zoneID)
        let note = Note(noteRecord: noteRecord)
        
        topicCache.performReaderBlockAndWait {
            note.record[Schema.Note.topic] = CKReference(record: topic.record, action: .deleteSelf)
            note.record.parent = CKReference(record: topic.record, action: .none)
        }
        
        noteViewController.topic = topic
        noteViewController.note = note
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.bringSubview(toFront: spinner)
        
        UIView.transition(with: tableView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
    }
    
    @IBAction func toggleZone(_ sender: AnyObject) {
        if let menuViewController = view.window?.rootViewController as? MenuViewController {
            menuViewController.toggleMenu()
        }
    }
}

extension MainViewController { // MARK: - Actions and Handlers
    
    // Notification should be posted from main thread by the cache class.
    //
    @objc func topicCacheDidChange(_ notification: Notification) {
        
        if let topicCache = topicCacheOrNil {
            title = topicCache.database.name + "." + topicCache.zone.zoneID.zoneName
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            title = ""
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    @IBAction func editTopic(_ sender: AnyObject) { // Edit button action.

        guard let sectionTitleView = (sender as? UIView)?.superview as? TopicSectionTitleView,
            sectionTitleView.editingStyle != .none else { return }

        guard let topicCache = topicCacheOrNil else { return }

        let alert: UIAlertController
        if sectionTitleView.editingStyle == .inserting {

            alert = UIAlertController(title: "New Topic.", message: "Creating a topic.",
                                      preferredStyle: .alert)
            alert.addTextField { textField -> Void in
                textField.placeholder = "Name. Use 'Unnamed' if no input."
            }
            alert.addAction(UIAlertAction(title: "New Topic", style: .default) {_ in
                
                guard let name = alert.textFields?[0].text else { return }
                let finalName = name.isEmpty ? "Unnamed" : name
                
                self.spinner.startAnimating()
                topicCache.addTopic(with: finalName)
            })
            
        } else { // Now sectionTitleView.editingStyle == .deleting.
            
            let topic: Topic = topicCache.performReaderBlockAndWait {
                return topicCache.topics[sectionTitleView.section]
            }
            alert = UIAlertController(title: "Deleting Topic.",
                                      message: "Would you delete the topic and all its notes?",
                                      preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default) {_ in
                self.spinner.startAnimating()
                topicCache.deleteTopic(topic)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
        
    @IBAction func shareTopic(_ sender: AnyObject) { // Share button action.
        
        guard let sectionTitleView = (sender as? UIView)?.superview as? TopicSectionTitleView,
            let topicCache = topicCacheOrNil else { return }
        
        spinner.startAnimating()
        
        let topicRecord: CKRecord = topicCache.performReaderBlockAndWait {
            return topicCache.topics[sectionTitleView.section].record
        }
        
        // Completionhandler is called from the same queue where the prepareSharingController is called,
        // so we don't need to dispatch to main.
        // Topic name here may not unique so use a UUID string here.
        //
        topicCache.container.prepareSharingController( rootRecord: topicRecord, participantLookupInfos: nil,
                                                       database: topicCache.database,
                                                       zone: topicCache.zone) { controller in
                guard let sharingController = controller else {

                    let title = "Failed to share."
                    let message = "Can't set up a valid share object."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true) { self.spinner.stopAnimating() }
                    
                    return
                }
                
                // Save the root record for being used in UICloudSharingControllerDelegate methods,
                // and presentt the UICloudSharingController.
                //
                self.rootRecord = topicRecord
                sharingController.delegate = self
                sharingController.availablePermissions = [.allowPublic, .allowPrivate, .allowReadOnly, .allowReadWrite]
                self.present(sharingController, animated: true) { self.spinner.stopAnimating() }
        }
    }
}

extension MainViewController { // MARK: - UITableViewDataSource and UITableViewDelegate
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let topicCache = topicCacheOrNil else { return 0 }
        
        let topicCount = topicCache.performReaderBlockAndWait {
            return topicCache.topics.count
        }
        let isPrivateDB = topicCache.database.databaseScope == .private
        return isEditing && isPrivateDB ? topicCount + 1 : topicCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let topicCache = topicCacheOrNil else { return 0 }
        
        return topicCache.performReaderBlockAndWait {
    
            // When editing, there is an extra section for adding a new topic,
            // which shouldn't have any note.
            //
            if section == topicCache.topics.count {
                return 0 // No notes for the section for adding a new topic.
            }

            // Users should not "add" a note if they can't write the topic.
            //
            let topic = topicCache.topics[section]
            let noteCount = topic.notes.count
            
            if topic.permission != .readWrite {
                return noteCount
            }
            
            // Now either editing privateDB, or the user has enough permission.
            //
            return isEditing ? noteCount + 1 : noteCount
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let views = Bundle.main.loadNibNamed("TopicSectionTitleView", owner: self, options: nil)
        
        guard let sectionTitleView = views?[0] as? TopicSectionTitleView else { return nil }
        guard let topicCache = topicCacheOrNil else { return sectionTitleView }
        
        // Set up editing style for the section title view.
        // Default to add new status.
        //
        // Note that participants are not allowed to remove a topic because it is a root record.
        //
        var editingStyle: TopicSectionTitleView.EditingStyle = .inserting
        var title = "Add a topic"
        
        topicCache.performReaderBlockAndWait {
            guard section < topicCache.topics.count else { return }
            
            let topic = topicCache.topics[section]
            
            if topicCache.database.databaseScope == .shared {
                editingStyle = .none
            } else {
                editingStyle = isEditing && topic.permission == .readWrite ? .deleting : .none
            }
            
            title = (topic.record[Schema.Topic.name] as? String) ?? "Unnamed topic"
        }

        sectionTitleView.setEditingStyle(editingStyle, title: title)
        
        // In the shareDB, a participant is valid to "share" a shared record as well,
        // meaning they can show UICloudShareController for the following purpose:
        // 1. See the list of invited people.
        // 2. Send a copy of the share link to others (only if the share is public.
        // 3. Leave the share.
        // So we don't need to hide the Share button in that case.
        //
        sectionTitleView.section = section
        return sectionTitleView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let topicCache = topicCacheOrNil else { fatalError("\(#function): topicCache shouldn't be nil!") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellReusableID.subTitle, for: indexPath)
        
        var title: String? = "Add a note"

        topicCache.performReaderBlockAndWait {
            let topic = topicCache.topics[indexPath.section]
            
            if indexPath.row < topic.notes.count {
                title = topic.notes[indexPath.row].record[Schema.Note.title] as? String
            }
        }
        
        cell.textLabel!.text = title
        cell.detailTextLabel?.text = nil
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        guard let topicCache = topicCacheOrNil else { fatalError("\(#function): topicCache shouldn't be nil") }

        return topicCache.performReaderBlockAndWait {
            
            let topic = topicCache.topics[indexPath.section]
            
            // In privateDB, permission is default to .readWrite for the record creator.
            // ShareDB is different:
            // 1. A participant can always remove the participation by presenting a UICloudSharingController
            // 2. A participant can change the record content if they have .readWrite permission.
            // 3. A participant can add a record into a parent if they have .readWrite permission.
            // 4. A participant can remove a record added by themselves from a parent.
            // 5. A participant can not remove a root record if they are not the creator.
            // 6. Users can not "add" a note if they can't write the topic. (Implemented in MainViewController.numberOfRowsInSection)
            //
            if topic.notes.count == indexPath.row {
                return .insert
            }
            
            let note = topic.notes[indexPath.row]
            
            if topicCache.database.databaseScope == .shared {
                let isCurrentUser = note.record.creatorUserRecordID?.recordName == CKCurrentUserDefaultName
                return isCurrentUser ? .delete : .none
            }
            
            return note.permission == .readWrite ? .delete : .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let topicCache = topicCacheOrNil else { return }

        if editingStyle == .delete {
            spinner.startAnimating()
            let (topic, note): (Topic, Note) = topicCache.performReaderBlockAndWait {
                let topic = topicCache.topics[indexPath.section]
                return (topic, topic.notes[indexPath.row])
            }
            topicCache.deleteNote(note, topic: topic)
            
        } else if editingStyle == .insert {

            let topic = topicCache.performReaderBlockAndWait {
                return topicCache.topics[indexPath.section]
            }
            performSegue(withIdentifier: SegueID.mainAddNew, sender: topic)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController { // MARK: - UICloudSharingControllerDelegate
    
    // Provide a meaningful title to the UICloudSharingController invitation screen
    //
    func itemTitle(for csc: UICloudSharingController) -> String? {

        guard let record = rootRecord else { return nil }

        if record.recordType == Schema.RecordType.topic {
            return record[Schema.Topic.name] as? String
        } else {
            return record[Schema.Note.title] as? String
        }
    }

    // When a topic is shared successfully, this method is called. The CKShare should have been created,
    // and the whole share hierarchy should have been updated in server side. So fetch the changes and
    // update the local cache.
    //
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        
        guard let topicCache = topicCacheOrNil else {
            fatalError("\(#function): zoneCache shouldn't be nil!")
        }
        topicCache.fetchChanges()
    }
    
    // When a share is stopped and this method is called, the CKShare record should have been removed and
    // the root record should have been updated in the server side. So fetch the changes and update
    // the local cache.
    //
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        
        // Stop sharing can happen on two scenarios: an owner stops a share or a participant removes self from a share.
        // In the former case, no visual things will be changed in the owner side (privateDB).
        // In the latter case, the share will disappear from the sharedDB.
        // If the share is the only item in the current zone, the zone should also be removed.
        //
        // Fetching immediately here may not get all the changes because the server side needs a while to index.
        //
        guard let zoneCache = zoneCacheOrNil, let topicCache = topicCacheOrNil else { return }
        
        // Update the local cache to update the UI immediately.
        //
        if topicCache.database.databaseScope == .shared, let record = rootRecord {
            
            topicCache.deleteCachedRecord(record)
            
            let topicCount = topicCache.performReaderBlockAndWait { return topicCache.topics.count }
            if topicCount == 0 {
                if let index = zoneCache.databases.index(where: { $0.cloudKitDB.databaseScope == .shared }) {
                    zoneCache.deleteCachedZone(topicCache.zone, database: zoneCache.databases[index])
                    return // deleteCachedZone wil trigger a zone switching.
                }
            }
        }
        topicCache.fetchChanges() // Fetch the changes to completely sync with the server.
    }
    
    // Failing to save a share, show an alert and refersh the cache to avoid inconsistent status.
    //
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        
        // Use error message directly for better debugging the error.
        //
        let alert = UIAlertController(title: "Failed to save a share.",
                                      message: "\(error) ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true) {
            self.spinner.stopAnimating()
        }
        
        // Fetch the root record from server and upate the rootRecord sliently.
        // .fetchChanges doesn't return anything here, so fetch with the recordID.
        //
        if let topicCache = topicCacheOrNil, let rootRecordID = rootRecord?.recordID {
            topicCache.updateWithRecordID(rootRecordID)
        }
    }
}
