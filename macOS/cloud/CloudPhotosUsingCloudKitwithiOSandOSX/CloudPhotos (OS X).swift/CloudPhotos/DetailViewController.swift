/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This sample's detail view controller showing the attributes of a specific CKRecords.
*/

import Cocoa
import MediaLibrary

class DetailViewController : NSViewController, PhotoViewDelegate {
    // MARK: - Constants
    
    private enum TabIndex: Int {
        case tabOne = 0
        case tabTwo = 1
    }
    
    struct SegueIdentifier {
        static let mapPhoto = "mapPhoto"
        static let showPhoto = "showPhoto"
        static let editPhoto = "editPhoto"
    }
    
    var detailViewDelegate: DetailViewControllerDelegate! = nil

    // MARK: - Properties
    
    @IBOutlet private weak var photoImageView: PhotoView!
    @IBOutlet private weak var photoNameField: NSTextField!
    @IBOutlet private weak var photoOwnerField: NSTextField!
    @IBOutlet private weak var photoDateField: NSTextField!
    @IBOutlet private weak var photoLocationField: NSTextField!
    @IBOutlet private weak var mapButton: NSButton!
    @IBOutlet private weak var openPhotoButton: NSButton!
    
    @IBOutlet private weak var ownerProgressIndicator: NSProgressIndicator!
    
    @IBOutlet private weak var tabView : NSTabView!
    
    // Listen for updates due to push notification processing, so we can update our UI.
    private var notifObserver : NSObjectProtocol!
    
    // MARK: - Value Transformers
    
    // Transformer to converts MLMediaObject to NSImage (used by Interface Builder).
    let imageTransformer: MediaObjectToImageTransformer = {
        
        let imageTransformer = MediaObjectToImageTransformer()
        // Add to the name-based registry for shared objects used when
        // loading nib files with transformers specified by name in Interface Builder.
        //
        ValueTransformer.setValueTransformer(imageTransformer, forName: NSValueTransformerName("MediaObjectToImageTransformer"))
        
        return imageTransformer
    }()
    // Transformer to converts MLMediaObject to Title (used by Interface Builder).
    let titleTransformer: MediaObjectToTitleTransformer = {
        
        let titleTransformer = MediaObjectToTitleTransformer()
        // Add to the name-based registry for shared objects used when
        // loading nib files with transformers specified by name in Interface Builder.
        //
        ValueTransformer.setValueTransformer(titleTransformer, forName: NSValueTransformerName("MediaObjectToTitleTransformer"))
        return titleTransformer
    }()
    // transformer to converts MLMediaObject to Location (used by Interface Builder).
    let locationTransformer: MediaObjectToLocationTransformer = {
        
        let locationTransformer = MediaObjectToLocationTransformer()
        // Add to the name-based registry for shared objects used when
        // loading nib files with transformers specified by name in Interface Builder.
        //
        ValueTransformer.setValueTransformer(locationTransformer, forName: NSValueTransformerName("MediaObjectToLocationTransformer"))
        return locationTransformer
    }()
    // transformer to converts MLMediaObject to Location (used by Interface Builder).
    let dateTransformer: MediaObjectToModDateTransformer = {
        
        let dateTransformer = MediaObjectToModDateTransformer()
        // Add to the name-based registry for shared objects used when
        // loading nib files with transformers specified by name in Interface Builder.
        //
        ValueTransformer.setValueTransformer(dateTransformer, forName: NSValueTransformerName("MediaObjectToModDateTransformer"))
        return dateTransformer
    }()
    
    var detailItemRecord: CloudPhoto! {
        didSet {
            if detailItemRecord == nil {
                // Switch to tab 0 for the no selected photo UI.
                //
                tabView.selectTabViewItem(at: TabIndex.tabOne.rawValue)
            }
            else {
                // Switch to tab 1 for the detailed photo UI.
                //
                tabView.selectTabViewItem(at: TabIndex.tabTwo.rawValue)
                
                // name:
                photoNameField.stringValue = detailItemRecord.photoTitle
                photoNameField.isEnabled = detailItemRecord.isMyPhoto

                // owner:
                // Provide the owner of the current photo.
                photoOwnerField.stringValue = "" // Clear the owner field before starting.
                
                // Before obtaining the photo owner's name, check if we have our cloud service.
                CloudManager.cloudServiceAvailable { [weak self] (available) -> Void in
                    if available {
                        
                        // Start progress indicator in its place in case photoOwner() takes some time.
                        self?.ownerProgressIndicator.isHidden = false
                        self?.ownerProgressIndicator.startAnimation(self)
                        
                        // Ask for the familyName of the owner of this photo.
                        self?.detailItemRecord.photoOwner() { [weak self] (owner) in  // owner return the familyName
                            self?.ownerProgressIndicator.isHidden = true
                            self?.ownerProgressIndicator.stopAnimation(self)
                            
                            if let userName = owner {
                                self?.photoOwnerField.stringValue = userName
                                self?.photoOwnerField.textColor = NSColor.labelColor
                            }
                            else {
                                self?.setUnknownOwner()
                            }
                        }
                    }
                    else {
                        self?.setUnknownOwner()
                        
                        // No editing this photo while the network is unavailable.
                        self?.photoNameField.isEnabled = false
                    }
                }
                
                // photo date:
                if let photoDate = detailItemRecord.photoDate {
                    photoDateField.stringValue = dateFormatter.string(from: photoDate as Date)
                }
                
                // photo:
                photoImageView.image = detailItemRecord.photoImage
                openPhotoButton.isEnabled = detailItemRecord.photoImage != nil
                
                // Set address to unavailable for now until we know of a valid one.
                photoLocationField.stringValue = NSLocalizedString("Location Unavailable", comment: "")
                photoLocationField.textColor = NSColor.gray
                guard let location = detailItemRecord.photoLocation else {
                    mapButton.isEnabled = false
                    return
                }
                
                // location:
                // The map button enables/disables according to a valid CLLocation.
                mapButton.isEnabled = true
 
                // Get nearby readable address.
                geocoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
                    if placemarks != nil && placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        
                        var locationString = ""
                        if placemark.thoroughfare != nil {
                            locationString = String(format:"%@ ", placemark.thoroughfare!)
                        }
                        if placemark.locality != nil {
                            locationString = locationString + String(format:"%@ ", placemark.locality!)
                        }
                        if placemark.administrativeArea != nil {
                            locationString = locationString + String(format:"%@ ", placemark.administrativeArea!)
                        }
                        if locationString.characters.count > 0 {
                            self?.photoLocationField.stringValue = locationString
                            self?.photoLocationField.textColor = NSColor.labelColor
                        }
                    }
                })
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    private let geocoder: CLGeocoder = {
        let geocoder = CLGeocoder()
        return geocoder
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updateContentNotifName : NSNotification.Name = NSNotification.Name(APLCloudManager.updateContentWithNotification())
        
        // Listen for updates due to push notification processing, so we can update our UI.
        notifObserver = NotificationCenter.default.addObserver(
            forName: updateContentNotifName,
            object: nil,
            
            queue: OperationQueue.main) { notification in
                
                // A push notification (CKQueryNotification) has arrived,
                // update our table for added, removed or updates photos.
                //
                let queryNotification = notification.object as! CKQueryNotification
                let reason = queryNotification.queryNotificationReason
                let recordID = queryNotification.recordID! as CKRecordID
                
                // Notify the splitview's master and detail view controllers of this notification.
                self.handlePush(recordID, reason:reason)
            }
        
        photoImageView.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(notifObserver)
    }
    
    /// Changes the owner field to unknown state in disabled gray.
    private func setUnknownOwner() {
        photoOwnerField.stringValue = NSLocalizedString("Unknown User Name", comment: "")
        photoOwnerField.textColor = NSColor.gray
    }
    
    /// Utility method to display modification Error.
    private func showModifiedError(messageStr: String) {
        let alert = NSAlert()
        alert.addButton(withTitle: NSLocalizedString("OK Button Title", comment: ""))
        alert.messageText = NSLocalizedString("Unable to change photo message", comment: "")
        alert.informativeText = messageStr
        alert.alertStyle = .informational
        alert.beginSheetModal(for: view.window!, completionHandler: nil)
    }
    
    // MARK: - Push Notifications
    
    /**
    Called by our AppDelegate to handle a specific push notification of a specifc CKRecordID,
    that photo could have beed added, deleted or updated.  This is done silently.
    */
    func handlePush(_ recordID: CKRecordID, reason: CKQueryNotificationReason) {
        if detailItemRecord != nil {
            if recordID.isEqual(detailItemRecord.cloudRecord.recordID) { // Is it our photo that's being changed?
                switch (reason) {
                case .recordUpdated:
                    // Our current photo has come in that was updated.
                    //
                    if view.window!.sheets.count == 0 {
                        
                        let alert = NSAlert()
                        alert.addButton(withTitle: NSLocalizedString("OK Button Title", comment: ""))
                        
                        let strFormat = NSLocalizedString("Photo Generic Changed Notif Message", comment: "")
                        let deletedRecordTitle = detailItemRecord.photoTitle
                        alert.messageText = String(format: strFormat, deletedRecordTitle)
                        alert.alertStyle = .informational
                        
                        alert.beginSheetModal(for: view.window!, completionHandler: { (result) -> Void in
                            
                            CloudManager.fetchRecord(with: recordID) { [weak self] (foundRecord, error) in
                                guard let foundRecord = foundRecord else { return }
                                
                                // Create the CloudPhoto object with the associated CKRecord.
                                self?.detailItemRecord = CloudPhoto(record: foundRecord)
                            }
                        })
                    }
                    break
                
                default: break
                }
            }
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailViewController.SegueIdentifier.mapPhoto {
            let mapVC = segue.destinationController as! MapViewController
            mapVC.mapLocation = detailItemRecord.photoLocation
        }
        else if segue.identifier == DetailViewController.SegueIdentifier.showPhoto  {
            // Hand off our image to the image view controller popover.
            let imageVC = segue.destinationController as! ImageViewController
            imageVC.image = photoImageView.image
        }
        else if segue.identifier == DetailViewController.SegueIdentifier.editPhoto {
            // We are about to modify an existing photo (which opens ChoosePhotoViewController).
        }
    }
    
    // MARK: - Actions
    
    @IBAction func doneEditingName(_ sender: NSTextField) {
        // Make sure we have a valid photo.
        guard let photoRecord = detailItemRecord else { return }
        
        let photoName = photoRecord.photoTitle

        if photoNameField.stringValue != photoName {
            // Name field does not match, which means the user changed it, so we save this change.
            
            // Save the photo with the new name.
            detailItemRecord.photoTitle = photoNameField.stringValue
                
            CloudManager.modifyRecord(detailItemRecord.record(), completionHandler: { [weak self] (modifiedRecord, error) -> Void in
                if error != nil {
                    self?.showModifiedError(messageStr: (error?.localizedDescription)!)
                    
                    // Revert the photo name field back to its original value due to the error.
                    self?.photoNameField.stringValue = photoName
                }
                else {
                    // Create the CloudPhoto object with the associated CKRecord.
                    self?.detailItemRecord = CloudPhoto(record: modifiedRecord!)
                    
                    // Inform our delegate (master table view) to change the actual title in its table to the new title.
                    if let delegate = self?.detailViewDelegate {
                        delegate.didChangeCloudRecord(self!, photoRecord: (self?.detailItemRecord)!)
                    }
                }
            })
        }
    }
    
    // MARK: - PhotoViewDelegate
    
    func isPhotoChangeable(_ photoView: PhotoView) -> Bool {
        return detailItemRecord.isMyPhoto
    }
    
    // Delegate responsible for updating this detail view with the newly received media object.
    func didReceiveMediaObject(_ photoView: PhotoView, mediaObject: MLMediaObject?) {

        // If the incoming media object is nil, the user performed a delete operation on this photo.
        if (mediaObject == nil)
        {
            let alert = NSAlert()
            alert.addButton(withTitle: NSLocalizedString("OK Button Title", comment: ""))
            alert.addButton(withTitle: NSLocalizedString("Cancel Button Title", comment: ""))
            
            alert.messageText = NSLocalizedString("Confirm Delete Image", comment:"")
            alert.informativeText = NSLocalizedString("Confirm Delete Image Detail", comment: "")
            alert.alertStyle = .warning
            
            alert.beginSheetModal(for: view.window!, completionHandler: { (result) -> Void in
                if result == NSAlertFirstButtonReturn {
                    // User wants to remove this photo (the user deleted the photo image itself).
                    self.detailItemRecord.photoDate = nil
                    self.detailItemRecord.photoLocation = nil
                    self.detailItemRecord.photoImage = nil
                    self.detailItemRecord.photoTitle = NSLocalizedString("Untitled Title", comment: "")
                    
                    CloudManager.modifyRecord(self.detailItemRecord.record(), completionHandler: { [weak self] (modifiedRecord, error) -> Void in
                        if error != nil {
                            self?.showModifiedError(messageStr: (error?.localizedDescription)!)
                        }
                        else {
                            // Create the new CloudPhoto object with the associated CKRecord.
                            self?.detailItemRecord = CloudPhoto(record: modifiedRecord!)
                            
                            // Inform our delegate to change the actual title in its table to the new title.
                            if let delegate = self?.detailViewDelegate {
                                delegate.didChangeCloudRecord(self!, photoRecord: self!.detailItemRecord)
                            }
                        }
                    })
                }
            })
        }
        else {
            if let image = imageTransformer.transformedValue(mediaObject) {
                if let date = dateTransformer.transformedValue(mediaObject) {
                    let location = locationTransformer.transformedValue(mediaObject)
                        if let title = titleTransformer.transformedValue(mediaObject) {
          
                            // Only set the title directly if we have a valid one.
                            if ((title as? String)!.characters.count > 0) {
                                detailItemRecord.photoTitle = (title as? String)!
                            }
                            detailItemRecord.photoDate = date as? Date
                            detailItemRecord.photoLocation = location as? CLLocation
                            
                            // Update the photo, this will create a sized down/compressed cached image in the caches folder.
                            let imageURL = CloudManager.createCachedImage(from: image as! NSImage)
                            if imageURL != nil {
                                detailItemRecord.setPhotoImageURL(imageURL!)
                                
                                CloudManager.modifyRecord(detailItemRecord.record(), completionHandler: { [weak self] (modifiedRecord, error) -> Void in
                                    if error != nil {
                                        self?.showModifiedError(messageStr: (error?.localizedDescription)!)
                                    }
                                    else {
                                        // Create the new CloudPhoto object with the associated CKRecord.
                                        self?.detailItemRecord = CloudPhoto(record: modifiedRecord!)
                                        
                                        // Inform our delegate to change the actual title in its table to the new title.
                                        if let delegate = self?.detailViewDelegate {
                                            delegate.didChangeCloudRecord(self!, photoRecord: self!.detailItemRecord)
                                        }
                                    }
                                })
                            }
                        }
                }
            }
        }
    }
    
    // Delegate responsible for updating this detail view with the newly received image.
    func didReceiveImage(_ photoView: PhotoView, image: NSImage?) {
        
        // Raw images do not have a specific date, so use today's date/time
        detailItemRecord.photoDate = Date()
        
        // Raw images do not have a specific location.
        detailItemRecord.photoLocation = nil
        
        // Update the photo, this will create a sized down/compressed cached image in the caches folder.
        let imageURL = CloudManager.createCachedImage(from: image)
        if imageURL != nil {
            detailItemRecord.setPhotoImageURL(imageURL!)
        } else {
            detailItemRecord.photoImage = nil
        }
        
        // Update the photo record.
        CloudManager.modifyRecord(detailItemRecord.record(), completionHandler: { [weak self] (modifiedRecord, error) -> Void in
            if error != nil {
                self?.showModifiedError(messageStr: (error?.localizedDescription)!)
            }
            else {
                // Create the new CloudPhoto object with the associated CKRecord.
                self?.detailItemRecord = CloudPhoto(record: modifiedRecord!)
                
                // Inform our delegate to change the actual title in its table to the new title.
                if let delegate = self?.detailViewDelegate {
                    delegate.didChangeCloudRecord(self!, photoRecord: self!.detailItemRecord)
                }
            }
        })
    }
    
}

// MARK: - DetailViewControllerDelegate

protocol DetailViewControllerDelegate {
    func didChangeCloudRecord(_ detailViewController: DetailViewController, photoRecord: CloudPhoto)
}

