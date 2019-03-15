/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This sample's application delegate to push notifications (CKSubscriptions) from CloudKit.
*/

import Cocoa
import MediaLibrary

// Access to the global APLCloudManager object throughout (input is your iCloud container ID)

let container_ID = "your_real_container_id"

// Create our media library instance to get photo pasteboard data.
var CloudManager: APLCloudManager = {
    return APLCloudManager.sharedInstance(container_ID)
}()

@NSApplicationMain
class AppDelegate : NSObject, NSApplicationDelegate, APLCloudManagerDelegate {
    // MARK: - Application Life Cycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // We want to be notified by our CloudManager when the user logs in or out.
        CloudManager.delegate = self
        
        // Register for push notifications (from CloudKit)
        // Necessary to receive local or remove notifications.
        //
        let userNotificationTypes: NSRemoteNotificationType = [.alert, .badge, .sound]
        NSApplication.shared().registerForRemoteNotifications(matching: userNotificationTypes)
        
        // Setup and open the photo browser to only show photos.
        photoBrowser.mediaLibraries = .image
        openPhotoBrowser(self)
    }

    // MARK: - NSMediaLibraryBrowserController
    
    let photoBrowser = NSMediaLibraryBrowserController.shared()
    
    @IBAction func openPhotoBrowser(_ sender: Any) {
        if !photoBrowser.isVisible {
            photoBrowser.togglePanel(self)
        }
    }
    
    // MARK: - Accessors
    
    func splitViewController() -> SplitViewController {
        let mainWindow = NSApplication.shared().windows[0]
        return mainWindow.contentViewController as! SplitViewController
    }
    
    func masterViewController() -> MasterViewController {
        // Notify the splitview's master and detail view controllers of this notification.
        return splitViewController().masterViewController
    }
    
    func detailViewController() -> DetailViewController {
        // Notify the splitview's master and detail view controllers of this notification.
        return splitViewController().detailViewController
    }
    
    // MARK: - Push Notifications
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //print("CloudPhotos: Registered for Push notifications with token:\(deviceToken)\n")
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("CloudPhotos: Failed to register for Push notifications with token:\(error)\n")
    }
    
    /// Attempt to find the owner of that recordID from this CKQueryNotification and report it.
    func reportUserFromNotification(_ queryNotification: CKQueryNotification) {
        CloudManager.fetchRecord(with: queryNotification.recordID) { (foundRecord, error) in
    
            guard let foundRecord = foundRecord else { return }

            // find out the user who affected this photo
            CloudManager.fetchUserName(from: foundRecord.creatorUserRecordID) { (familyName) in
        
                guard familyName != nil else { return }
                
                // We are only interested in the kPhotoTitle attribute
                // (because we set the CKSubscription's CKNotificationInfo 'desiredKeys' when we subscribed earlier).
                //
                let recordFields: Dictionary = queryNotification.recordFields!
                let photoTitle = recordFields[APLCloudManager.photoTitleAttribute()] as! String
                
                // here we can examine the title of the photo without a query
                let reason = queryNotification.queryNotificationReason
                var baseMessage = String()
                switch (reason) {
                case .recordCreated:
                    baseMessage = NSLocalizedString("Photo Added Added Notif Message", comment: "")
                case .recordUpdated:
                    baseMessage = NSLocalizedString("Photo Changed Notif Message", comment: "")
                case .recordDeleted:
                    baseMessage = NSLocalizedString("Photo Removed Notif Message", comment: "")
                }
                
                let finalMessage = String(format:baseMessage, photoTitle, familyName!)
                print(finalMessage)
            }
        }
    }

    /**
     This method will be invoked even if the application resumed because of the remote notification.
        The respective delegate methods will be invoked first. Note that this behavior is in contrast to
        application:didReceiveRemoteNotification:, which is not called in those cases,
        and which will not be invoked if this method is implemented.
     */
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        // for debugging:
        // print("CloudPhotos: didReceiveRemoteNotification: \(userInfo)\n")
        
        // note: userInfo must have this:
        //      "content-available" = 1;
        // also: In Info.plist:
        //          <key>UIBackgroundModes</key>
        //          <array>
        //          <string>remote-notification</string>
        //          </array>
        //
        // NOTE:
        // The content-available property with a value of 1 lets the remote notification act as a “silent” notification.
        //
        // NOTE:
        // If the notification has 1) alert, 2) badge, or 3) soundKey, then CloudKit uses priority 10, otherwise is uses 5.
        //
        // all incoming push notifications are handled inside our CloudManager object,
        // view controllers of this app will be called via NSNotificationCenterto to update their UI
        //
        CloudManager.processNotifications()
        
        // If you want to process the push here, you can do this:
        if let userInfo = userInfo as? [String: NSObject] {
            
            // For debugging:
            let cloudKitNotification = CKNotification(fromRemoteNotificationDictionary: userInfo)
            let notificationType = cloudKitNotification.notificationType
            if notificationType == .query {
                //let notificationID = cloudKitNotification.notificationID
                //let containerIdentifier = cloudKitNotification.containerIdentifier
                //print("CloudPhotos: Push notification received: \(cloudKitNotification.alertBody)\n")
                //print("notifType = \(notificationType), notifID = \(notificationID), containerID = \(containerIdentifier)")
            }
        }
    }
    
    // MARK: - APLCloudManagerDelegate
    
    /// Used to refresh our UI, when the user signs in or out of iCloud.
    func userLoginChanged() {
        // Notify the splitview's master view controller of the login change to give it chance to refresh its UI.
        let masterViewController = splitViewController().masterViewController
        masterViewController?.loginUpdate()
    }
    
}

