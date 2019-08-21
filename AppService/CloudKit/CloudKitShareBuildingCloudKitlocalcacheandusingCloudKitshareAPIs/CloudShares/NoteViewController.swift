/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller class for viewing and editing notes.
 */

import UIKit
import CloudKit

final class NoteViewController: SpinnerViewController { // MARK: - View controller life cycle
    
    private var topicCacheOrNil: TopicLocalCache? {
        return (UIApplication.shared.delegate as? AppDelegate)?.topicCacheOrNil
    }

    // The newly adding note and its topic. They are set up in MainViewController.prepare.
    //
    var topic: Topic!
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of:self).topicCacheDidChange(_:)),
            name: .topicCacheDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension NoteViewController { // MARK: - Action handlers
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        guard let topicCache = topicCacheOrNil else { return }
        
        // Validate inputs. Make sure the title field isn't empty.
        //
        let indexPath = IndexPath(row: 1, section: 0)
        guard let titleCell = tableView.cellForRow(at: indexPath) as? TextFieldCell else { return }
        
        guard let input = titleCell.textField.text, input.isEmpty == false else {
            
            let alert = UIAlertController(title: "The title field is empty.",
                                          message: "Please input a title and try again.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            present(alert, animated: true)
            return
        }
        
        spinner.startAnimating()
        
        note.record[Schema.Note.title] = input as CKRecordValue
        topicCache.addNote(note, topic: topic)
        dismiss(animated: true) { self.spinner.stopAnimating() }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension NoteViewController { // MARK: - Local cache change notificaiton
    
    @objc func topicCacheDidChange(_ notification: Notification) { // Notification is posted in main thread.
        
        // Alert (and return to main screen) when the topic doesn't exist. This can happen when:
        // 1. The topic is removed by other peers.
        // 2. The zone is removed, thus the app switched to a new zone.
        // 3. topicCache is nullified (because the account became unavailable).
        //
        guard let topicCache = topicCacheOrNil else { return self.alertTopicNotExist() }
        
        let topicRecordOrNil: CKRecord? = topicCache.performReaderBlockAndWait {
            let existing = topicCache.topics.contains { $0.record.recordID == self.topic.record.recordID }
            return existing ? self.topic.record : nil
        }
        guard let topicRecord = topicRecordOrNil else { return self.alertTopicNotExist() }

        // Now the topic is there, handle the notification payload, if any.
        //
        guard let payload = (notification.object as? TopicCacheDidChange)?.payload else { return }
        
        // If the note's topic was changed, alert the user and refresh the UI.
        // This sample dosen't really change a topic name but that can be done using CloudKit Dashboard.
        //
        guard payload.recordsChanged.contains(where: { $0.recordID == topicRecord.recordID })
            else { return }

        let topicCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        topicCell?.detailTextLabel?.text = topicRecord[Schema.Topic.name] as? String
    }
    
    private func alertTopicNotExist() {
        
        let alert = UIAlertController(title: "This note's topic doesn't exist now.",
                                      message: "Tap OK to go back to the main screen.",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {_ in
            
            self.spinner.startAnimating()
            self.dismiss(animated: true) { self.spinner.stopAnimating() }
        })
        
        present(alert, animated: true)
    }
}

extension NoteViewController { // MARK: - UITableViewDataSource and UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let topicCache = topicCacheOrNil else { fatalError("Topic cache should not be nil now!") }
        
        let identifiers = [TableCellReusableID.rightDetail, TableCellReusableID.textField]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.row], for: indexPath)
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Topic"
            let topicName = topicCache.performReaderBlockAndWait { return topic.record[Schema.Topic.name] }
            cell.detailTextLabel?.text = topicName as? String
            
        } else if indexPath.row == 1, let textFieldCell = cell as? TextFieldCell {
            
            textFieldCell.titleLabel.text = "Title"
            textFieldCell.textField.placeholder = "Required"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
