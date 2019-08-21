/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This sample's master view controller listing all photos from CloudKit.
*/

import Cocoa
import SystemConfiguration

class MasterViewController : NSViewController, CLLocationManagerDelegate, DetailViewControllerDelegate {
    // MARK: - Constants
    
    struct SegueIdentifier {
        static let editPhoto = "editPhoto"    // segue name to edit the photo (opens ChoosePhotoViewController)
        static let addPhoto = "addPhoto"      // segue name to add a photo (opens ChoosePhotoViewController)
    }
    
    // NSSegmentedControl below the master table to add and remove photos.
    struct SegmentedControl {
        static let addSegment = 0
        static let removeSegment = 1
    }
    
    // KVO key for listening to selection changes in the NSArrayController.
    static let selectionIndexesKey = "selectionIndexes"
    
    // MARK: - Properties
    
    // Listen for updates due to push notification processing, so we can update our UI.
    private var notifObserver : NSObjectProtocol!
    
    // The array controller data source of photos
    @IBOutlet var photoArrayController: NSArrayController!
    
    // The data source for "photoArrayController" (used for accessing "all" photos regardless
    // of what's filtered by the search bar's predicate).
    lazy var photoArrayBacking = [CloudPhoto]()
    
    @IBOutlet weak var addRemoveSegmentedControl: NSSegmentedControl!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var refreshButton: NSButton!
    
    @IBOutlet weak var searchField: NSSearchField!
   
    // So we can inform the delegate of table selection changes (from the user or from the array controller).
    var delegate: MasterViewControllerDelegate?
    
    // Transformer to converts CKAsset to NSImage (used indirectly by Interface Builder).
    private let imageTransformer: AssetToImageTransformer = {
        let imageTransformer: AssetToImageTransformer = AssetToImageTransformer()
        
        // Add to the name-based registry for shared objects used when
        // loading nib files with transformers specified by name in Interface Builder.
        //
        ValueTransformer.setValueTransformer(imageTransformer, forName: NSValueTransformerName("AssetToImageTransformer"))
        return imageTransformer
    }()
    
    // MARK: - View Controller Lifecycle

    deinit {
        // No longer need to observe for these.
        photoArrayController.removeObserver(self, forKeyPath: MasterViewController.selectionIndexesKey)
        NotificationCenter.default.removeObserver(resumeObserver)
        NotificationCenter.default.removeObserver(suspendObserver)
        NotificationCenter.default.removeObserver(notifObserver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.isEnabled = true
        
        // Listen for app resume (to start tracking user location).
        resumeObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSApplicationDidBecomeActive,
            object: nil,
            queue: OperationQueue.main) { notification in
            
                if CLLocationManager.authorizationStatus() == .authorizedAlways
                {
                    self.locationManager.startUpdatingLocation()
                }
        }
        
        // Listen for app suspend (to stop tracking user location).
        suspendObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSApplicationDidResignActive,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in

                if CLLocationManager.locationServicesEnabled() {
                    self?.locationManager.stopUpdatingLocation()
                }
        }
        
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
                self.handlePush(recordID: recordID, reason:reason)
        }

        // Setup location services and configure our location manager.
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // Current Macs of 2016 use wifi for location, not GPS.
        
        // Listen for when the array controller changes it's selection.
        self.photoArrayController.addObserver(self, forKeyPath:"selectionIndexes", options:NSKeyValueObservingOptions.new, context:nil)
        
        // Before loading the photos check if we have our cloud service.
        CloudManager.cloudServiceAvailable { [weak self] (available) -> Void in
            if available {
                // Load all the photos.
                self?.loadPhotos {

                    // Restore the table view selection from last time.
                    if self!.selectedPhotoRecordName.characters.count > 0 {

                        // debugging:
                        // print("photos = \(photoArrayController.arrangedObjects)")

                        // Find the photo with the matching record name.
                        let recordID = CKRecordID(recordName: self!.selectedPhotoRecordName)
                        let photoIndex = self!.indexForPhoto(recordID: recordID)
                        if photoIndex != -1 {
                            // Found a proper index to select the photo.
                            self!.photoArrayController.setSelectionIndex(photoIndex)
                        }
                    }
                }
            }
        }
        
        // Restore the search field with the restored string value and unselect its text.
        guard self.searchBarString.characters.count > 0 else { return }
        self.searchField.stringValue = self.searchBarString
        self.searchField.performClick(self) // Force a refilter of the array controller.
    }

    // MARK: - User Interface
    
    /// Called by the NSArrayController to obtain it's sort descriptor (sort by photo title).
    func photoSortDescriptor() -> NSArray {
        // Used by our array controller through bindings to obtain it's sort descriptor.
        let sortDesc = NSSortDescriptor(key: "photoTitle", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        return [sortDesc]
    }
    
    /// Utility to start/stop spinning gear whenever network activity has started.
    private func startProgressIndicator(start: Bool) {
        progressIndicator.isHidden = !start
        if start {
            progressIndicator.startAnimation(self)
        }
        else {
            progressIndicator.stopAnimation(self)
        }
    }
    
    /// Disables the entire segmented control (both buttons).
    private func disableSegmentedControl() {
        addRemoveSegmentedControl.setEnabled(false, forSegment: SegmentedControl.addSegment)
        addRemoveSegmentedControl.setEnabled(false, forSegment: SegmentedControl.removeSegment)
    }
    
    /**
    Adjust the NSSegmentedControl (add/remove buttons), according to the
    login status and current selection in the master table.
    */
    private func adjustSegmentedControl() {
        
        // Check if we have our cloud service to properly set the state of add/remove buttons.
        if CloudManager.accountAvailable && CloudManager.userLoginIsValid {

            self.addRemoveSegmentedControl.setEnabled(true, forSegment: SegmentedControl.addSegment)
            
            // Check if we have a photo selected adjust the segmented control remove segment accordingly.
            let selectedRow = self.photoArrayController.selectionIndexes.first
        
            guard (selectedRow != NSNotFound && selectedRow != nil) else {
                // No selection, disable the remmove button.
                self.addRemoveSegmentedControl.setEnabled(false, forSegment: SegmentedControl.removeSegment)
                return
            }
            
            let photos = self.photoArrayController.arrangedObjects as! Array<AnyObject>
            let selectedPhoto = photos[selectedRow!] as! CloudPhoto
            
            self.addRemoveSegmentedControl.setEnabled(selectedPhoto.isMyPhoto, forSegment: SegmentedControl.removeSegment)
        }
        else {
            // Not logged in, disable add and remove of photos.
            self.disableSegmentedControl()
        }
    }
    
    func loginUpdate() {
        // The user has signed in or out of iCloud,
        // so we need to refresh our UI reflect user login, so re-load all the photos.
        //
        delegate!.didChangePhotoSelection(masterViewController: self, selection: -1)
        
        loadPhotos {
            // Photo loading completed.
        }
    }
    
    // MARK: - KVO

    /**
    Used for observing for NSArrayController selection changes:
    (selection changes as a result of filtering (user search) will not send NSTableViewSelectionDidChangeNotification),
    so we handle it right here to help target our detail view controller.
    */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == MasterViewController.selectionIndexesKey && object as! NSArrayController == photoArrayController {
            
            // Obtain the selection index from our array controller.
            let selection = (object as! NSArrayController).selectionIndex

            if delegate != nil {
                delegate!.didChangePhotoSelection(masterViewController: self, selection: selection)
            }
            
            // A different photo was selected, update the state of our segmented control
            // (i.e. enable/disable remove button if it's our photo or not).
            //
            adjustSegmentedControl()
            
            if selection == NSNotFound {
                selectedPhotoRecordName = String()
            }
            else {
                // Remember the selected photo for state restoration later at relaunch.
                let selectedPhoto = photoArrayController.selectedObjects[0] as! CloudPhoto
                selectedPhotoRecordName = selectedPhoto.record().recordID.recordName
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    // MARK: - Actions
    
    override func keyDown(with theEvent: NSEvent) {
        let characters = theEvent.characters!
        
        // Allow the user to delete photos by delete key.
        switch (characters as NSString).character(at: 0) {
        case unichar(NSDeleteFunctionKey),
             unichar(NSDeleteCharFunctionKey),
             unichar(NSDeleteCharacter):
            handleRemovePhoto()
        default: break
        }
    }
    
    /// Refreshes the table view list of CloudPhotos.
    @IBAction func refreshAction(_ sender: NSButton) {
        // A refresh of the photos list means clear the detail view,
        // this notifies the split view controller so it can clear it's detail view.
        //
        delegate!.didChangePhotoSelection(masterViewController: self, selection: -1)
        
        loadPhotos {
            // Photo loading completed.
        }
    }
    
    /// Action method for the segmented control that adds and removes CloudPhotos.
    @IBAction func addRemoveSegmentedControlAction(_ sender: NSSegmentedControl) {
        switch (sender.selectedSegment) {
        case SegmentedControl.addSegment:
            // User wants to add a photo, bring up ChoosePhotoViewController as a sheet input.
            
            // Create a CKRecord photo: generic title, current date/time, no location - and save it as a CloudPhoto instance.
            CloudManager.addNewRecord(NSLocalizedString("Untitled Title", comment: ""), date: NSDate() as Date!, location: nil) { [weak self] (record, error) in
                
                if record != nil && error == nil
                {
                    // Create the CloudPhoto object with the associated CKRecord.
                    let photo = CloudPhoto(record: record!)
                    photo.distanceFromUser = self!.photoDistanceFromUser(location: photo.photoLocation)
                    
                    self?.photoArrayController.addObject(photo)
                    self?.photoArrayController.setSelectedObjects([photo])
                }
            }
            
            let appDelegate = NSApplication.shared().delegate as! AppDelegate
            appDelegate.openPhotoBrowser(self)
            break
            
        case SegmentedControl.removeSegment:
            // User wants to remove the photo.
            handleRemovePhoto()
            break
            
        default: break
        }
    }

    // MARK: - Location Services

    // For tracking user location.
    private var currentLocation : CLLocation!
    private var locationManager = CLLocationManager()
    
    // Listen for app resume (to start tracking user location).
    private var resumeObserver : NSObjectProtocol!
    
    // Listen for app suspend (to stop tracking user location).
    private var suspendObserver : NSObjectProtocol!
    
    /// Helps compute the distance between the input "location" and our tracked user location.
    private func photoDistanceFromUser(location: CLLocation?) -> Double {
        var distance : Double = -1
        
        guard let location = location else { return distance }
        
        // Some photos might not have a valid location.
        if currentLocation != nil {
        
            // Distance is measures in meters.
            let distanceFromPhoto = currentLocation.distance(from: location)
            
            // Final distance is measured in kilometers.
            distance = distanceFromPhoto/100
        }
        
        return distance
    }
    
    /// User has changed/updated it's location.
    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
        // User has moved, store their location.
        currentLocation = newLocation

        // Stop looking, once we have a fix on the user's location.
        locationManager.stopUpdatingLocation()
        
        // Change the content of the photo list based on location (particularly for filtering photos near me).
        if oldLocation.distance(from: newLocation) > 5 {
            // Don't be notified too often, ignore movement less than 5 meters).
            for photo in photoArrayBacking {
                photo.distanceFromUser = photoDistanceFromUser(location: photo.photoLocation)
            }

            // Changing the backed array alone won't update the array controller, so set the array controller content.
            let indexes = NSIndexSet(indexesIn: NSMakeRange(0, photoArrayBacking.count))
            photoArrayController.willChange(.setting, valuesAt: indexes as IndexSet, forKey: "content")
            photoArrayController.content = photoArrayBacking
            photoArrayController.didChange(.setting, valuesAt: indexes as IndexSet, forKey: "content")
        }

        // Note: we will stop location tracking when the app is suspended and start it again when it resumes.
    }
    
    // MARK: - State Restoration
    
    // Restorable key for the currently selected photo on state restoration.
    private static let selectedPhotoRestoreKey = "selectedPhotoRestoreKey"
    
    // Restorable key for the search bar's search text on state restoration.
    private static let searchBarStringRestoreKey = "searchBarStringRestoreKey"
 
    var selectedPhotoRecordName = String() {
        didSet {
            // State restoration needs to know when this changes.
            invalidateRestorableState()
        }
    }
    var searchBarString = String() {
        didSet {
            // State restoration needs to know when this changes.
            invalidateRestorableState()
        }
    }
    
    /// Encode state. Helps save the restorable state of this view controller.
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(selectedPhotoRecordName, forKey: MasterViewController.selectedPhotoRestoreKey)
        coder.encode(searchField.stringValue, forKey: MasterViewController.searchBarStringRestoreKey)
        
        super.encodeRestorableState(with: coder)
    }

    /// Decode state.  Helps restore any previously stored state.
    override func restoreState(with coder: NSCoder) {
        super.restoreState(with: coder)
        
        if let selectedPhoto = coder.decodeObject(forKey: MasterViewController.selectedPhotoRestoreKey) as? String {
            // Remember this for later after the initial fetch finishes.
            selectedPhotoRecordName = selectedPhoto
        }
        if let searchBarStr = coder.decodeObject(forKey: MasterViewController.searchBarStringRestoreKey) as? String {
            // Remember this for later after the initial fetch finishes.
            searchBarString = searchBarStr
        }
    }
    
    // MARK: - Photo Management
    
    /// Obtains the index row number of the given recordID, -1 if it cannot be found.
    private func indexForPhoto(recordID: CKRecordID) -> Int {
        var foundIndex = -1
        
        let photos = photoArrayController.arrangedObjects as! [CloudPhoto]
        for (index, photo) in photos.enumerated() {
            if photo.record().recordID.isEqual(recordID)
            {
                foundIndex = index
                break // We found the photo record that matches the recordID.
            }
        }
        
        return foundIndex
    }
    
    /// Loads the entire set of CloudPhotos available to this app.
    private func loadPhotos(completionHandler: @escaping () -> Void) {
        // This could take some time.
        self.startProgressIndicator(start: true)
        
        // No additional refreshes allowed until it completes.
        self.refreshButton.isEnabled = false
        
        CloudManager.fetchRecords { [weak self] (records, error) -> Void in
            if error != nil {
                
                let errorCode = (error as! NSError).code
                
                switch errorCode {
                case CKError.Code.limitExceeded.rawValue:
                    // The request to the server was too large. Retry this request as a smaller batch.
                    break
                    
                case CKError.Code.serverRejectedRequest.rawValue:
                    // Service or server problems
                    // (may be because the record type is not defined in the schema yet or the
                    //  schema was removed from CloudKit Dashboard).
                    //
                    break
                    
                case CKError.Code.unknownItem.rawValue:
                    // Note we can get CKErrorUnknownItem for the first time the app is open
                    // (no records added to that container yet, no schema defined),
                    //
                    break
                
                case CKError.Code.networkUnavailable.rawValue:
                    // No network available
                    break
                
                default: break
                }
                
                // On CKErrorServiceUnavailable or CKErrorRequestRateLimited errors:
                // the userInfo dictionary may contain a NSNumber instance that specifies the period of time in seconds after
                // which the client may retry the request.  So here we will try again.
                //
                if errorCode == CKError.Code.serviceUnavailable.rawValue || errorCode == CKError.Code.requestRateLimited.rawValue
                {
                    let retryAfterDict = (error as! NSError).userInfo as AnyObject
                    var retryAfterValue = retryAfterDict[CKErrorRetryAfterKey]! as? DispatchTime
                    if retryAfterValue == nil {
                        retryAfterValue = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    }
                    print("Error: \(error!.localizedDescription). Recoverable, retry after \(retryAfterValue) seconds")
                    
                    DispatchQueue.main.asyncAfter(deadline: retryAfterValue!) {
                        self?.loadPhotos(completionHandler: completionHandler)
                    }
                }
                else
                {
                    // Due to an error, no records should be shown.
                    self?.photoArrayController.remove(contentsOf: self?.photoArrayController.arrangedObjects as! [AnyObject])
                }
            }
            else {
                // Remove the photos, in favor of new ones.
                let photos : NSArray = self?.photoArrayController.arrangedObjects as! NSArray
                if photos.count > 0 {
                    self?.photoArrayController.remove(contentsOf: self?.photoArrayController.arrangedObjects as! [AnyObject])
                }
                
                // All is good, as we get back an array of CKRecords, convert them to CloudPhoto objects.
                for record in records! {
                    
                    let photoRecord = record as! CKRecord
                    
                    // Create the CloudPhoto object with the associated CKRecord.
                    let photo = CloudPhoto(record: photoRecord)
                    photo.distanceFromUser = self!.photoDistanceFromUser(location: photo.photoLocation)

                    if !(self!.photoArrayController.arrangedObjects as! NSArray).contains(photoRecord) {
                        self?.photoArrayController.addObject(photo)
                    }
                }
            }
            
            self?.startProgressIndicator(start: false)
            self?.refreshButton.isEnabled = true
            
            // Load completed, adjust our segmented control based on login status.
            self?.adjustSegmentedControl()
            
            // Make sure to invoke our caller's completion handler to inform them we are done.
            completionHandler()
        }
    }
    
    /// Removes the selected CloudPhoto in the table view list.
    private func handleRemovePhoto() {
        let selectedRow = photoArrayController.selectionIndexes.first
        guard (selectedRow != NSNotFound) else { return }

        let photos = photoArrayController.arrangedObjects as! Array<AnyObject>
        let photoToDelete = photos[selectedRow!] as! CloudPhoto

        guard photoToDelete.isMyPhoto else { return }
        
        // We own this photo, so we are allowed to delete it.
        //
        let alert = NSAlert()
        alert.addButton(withTitle: NSLocalizedString("OK Button Title", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel Button Title", comment: ""))
        
        let strFormat = NSLocalizedString("Confirm Delete", comment:"")
        
        let deletedRecordTitle = photoToDelete.photoTitle
        
        alert.messageText = String(format:strFormat, deletedRecordTitle)
        alert.informativeText = NSLocalizedString("Confirm Delete Detail", comment: "")
        alert.alertStyle = .warning
        
        alert.beginSheetModal(for: view.window!, completionHandler: { (result) -> Void in
            if result == NSAlertFirstButtonReturn {
                self.startProgressIndicator(start: true)   // this could take some time

                CloudManager.deleteRecord(with: photoToDelete.record().recordID, completionHandler: { (recordID, error) -> Void in
                    
                    self.startProgressIndicator(start: false)
                    
                    if error == nil {
                        // Remove the deleted photo from our table.
                        self.photoArrayController.removeObject(photoToDelete)
                        
                        // This notifies the split view controller so it can update it's
                        // detail view (after delete no record selected).
                        self.delegate!.didChangePhotoSelection(masterViewController: self, selection: -1)
                    }
                })
            }
        })
    }

    // MARK: - NSSearchField Editing
    
    /// The search text in the search bar text has changed.
    override func controlTextDidChange(_ notif: Notification) {
        let searchField = notif.object as! NSSearchField
        searchBarString = searchField.stringValue
    }
    
    // MARK: - Table Updating - Push Notifications

    /**
    Called as a result of a subscription notification.  Updates just the table cell this CKRecordID is associated with,
    instead of just doing an entire table re-fetch, let's be efficient and just apply the update for the photo in question
    */
    private func updateTable(recordID: CKRecordID, reason: CKQueryNotificationReason) {
        if reason == .recordDeleted {
            // We are being asked to remove an existing photo.
            //
            let photoIndex = indexForPhoto(recordID: recordID)
            if photoIndex != -1 {
                // We found the photo that needs removing, remove it from the table.
                photoArrayController.remove(atArrangedObjectIndex: photoIndex)
            }
        }
        else {
            // We are being told a photo was added or updated.
            //
            startProgressIndicator(start: true)
            
            CloudManager.fetchRecord(with: recordID) { [weak self] (foundRecord, error) in
                guard (foundRecord != nil) else { return }
                
                self?.startProgressIndicator(start: false)
                
                if reason == .recordUpdated {
                    
                    // We found the photo that needs "updating", change our data source.
                    //
                    let photoIndex = self?.indexForPhoto(recordID: recordID)
                    if photoIndex! >= 0 {
                        self?.photoArrayController.remove(atArrangedObjectIndex: photoIndex!)
                        
                        // Reassign a new CloudPhoto object along with its associated CKRecord
                        // and the computed distance from the current user's location.
                        let photo = CloudPhoto(record: foundRecord!)
                        photo.distanceFromUser = self!.photoDistanceFromUser(location: photo.photoLocation)
                        self?.photoArrayController.addObject(photo)
                        self?.photoArrayController.setSelectedObjects([photo])
                    }
                }
                else if reason == .recordCreated {
                    // A photo needs to be added.
                    
                    var foundPhoto = false
                    
                    // ensure we don't add the object more than once
                    for photoToCheck in self?.photoArrayController.arrangedObjects as! [CloudPhoto] {
                        if photoToCheck.cloudRecord.recordID.recordName.isEqual(recordID.recordName) {
                            foundPhoto = true
                            break // We found the photo that matches the recordID.
                        }
                    }
                    if !foundPhoto {
                        // Create the CloudPhoto object with the associated CKRecord.
                        let photo = CloudPhoto(record: foundRecord!)
                        
                        photo.distanceFromUser = self!.photoDistanceFromUser(location: photo.photoLocation)
                        self?.photoArrayController.addObject(photo)
                    }
                }
            }
        }
    }
    
    /**
    Called by our AppDelegate to handle a specific push notification of a specifc CKRecordID,
    that photo could have beed added, deleted or updated.  This is done silently.
    */
    func handlePush(recordID: CKRecordID, reason: CKQueryNotificationReason) {
        // A photo has come in that was added, deleted or updated.
        //
        // Update just the table cell this CKRecord is associated with,
        // instead of just doing an entire table re-fetch, let's be efficient and just apply the update for the photo in question.
        //
        updateTable(recordID: recordID, reason: reason)
    }
    
    // MARK: - DetailViewControllerDelegate
    
    func didChangeCloudRecord(_ detailViewController: DetailViewController, photoRecord: CloudPhoto) {
        updateTable(recordID: photoRecord.record().recordID, reason: .recordUpdated)
    }
}

// MARK: - MasterViewControllerDelegate

/// Used for informing the delegate of the array controller selection change (as a result of filtering from the search field).
protocol MasterViewControllerDelegate {

    func didChangePhotoSelection(masterViewController: MasterViewController, selection: Int)
}

