/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 App delegate class, implementing App lifecycle methods and notification handler,
  and managing local cache life cycle.
 */

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)?
    var window: UIWindow?
    var zoneCacheOrNil: ZoneLocalCache?
    var topicCacheOrNil: TopicLocalCache?
    
    // Keep the share we accepted so that we can select the zone when the share comes in.
    //
    private var shareMetadataToOpen: CKShareMetadata?

    // Use CKContainer(identifier: <your custom container ID>) if not the default container.
    // Note that:
    // 1. iCloud container ID starts with "iCloud.".
    // 2. This will error out if iCloud / CloudKit entitlement is not well set up.
    //
    let container = CKContainer.default()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let storyboard = UIStoryboard(name: StoryboardID.main, bundle: nil)
        let mainNCOrNil = storyboard.instantiateViewController(withIdentifier: StoryboardID.mainNC)
        let zoneNCOrNil = storyboard.instantiateViewController(withIdentifier: StoryboardID.zoneNC)

        guard let mainNC = mainNCOrNil as? UINavigationController,
            let zoneNC = zoneNCOrNil as? UINavigationController else {
            fatalError("mainNC and zoneNC should be a UINavigationController!")
        }
        
        window?.rootViewController = MenuViewController(mainViewController: mainNC, menuViewController: zoneNC)
        window?.makeKeyAndVisible()
        
        // Observe the .zoneCacheDidChange and .zoneDidSwitch to update the topic cache if needed.
        //
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of:self).zoneCacheDidChange(_:)),
            name: .zoneCacheDidChange, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of:self).zoneDidSwitch(_:)),
            name: .zoneDidSwitch, object: nil)

        // Register for remote notification.
        // The local caches rely on subscription notifications, so notifications have to be granted in this sample.
        //
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            if let error = error {
                print("notificationCenter.requestAuthorization returns error: \(error)")
            }
            if granted != true {
                print("notificationCenter.requestAuthorization is not granted!")
            }
        }
        application.registerForRemoteNotifications()
        
        application.applicationIconBadgeNumber = 0
        
        // Save the current user token for user-switching check later.
        //
        ubiquityIdentityToken = FileManager.default.ubiquityIdentityToken
    
        // Checking account availability. Create local cache objects if the accountStatus is available.
        // .zoneCacheDidChange will be posted after the zone cache is built, which triggers the creation
        // of topic local cache.
        //
        checkAccountStatus(for: container) { available in
            guard available else { return self.handleAccountUnavailable() }
            self.zoneCacheOrNil = ZoneLocalCache(self.container)
        }
        return true
    }
    
    // When the application entering foreground again, check the user availabilityupdate local cache.
    // We aren't using .NSUbiquityIdentityDidChange because it is not supported on tvOS and watchOS.
    //
    func applicationWillEnterForeground(_ application: UIApplication) {

        application.applicationIconBadgeNumber = 0 // Clear the badge number.
        
        checkAccountStatus(for: container) { available in
            
            // Be sure to update the user token before leaving.
            //
            defer { self.ubiquityIdentityToken = FileManager.default.ubiquityIdentityToken }

            // No account available. The user logged out or iCloud Drive is disabled.
            //
            if available == false {
                self.handleAccountUnavailable()
                return
            }
            
            // If old token is nil, a new user logged in so load the cache for the new user.
            //
            guard let oldToken = self.ubiquityIdentityToken else {
                self.zoneCacheOrNil = ZoneLocalCache(self.container)
                return
            }
            
            // Account available but no user switching, don't need to do anything.
            // The changes from iCloud, if any, will go through CKNotifications.
            //
            if let newToken = FileManager.default.ubiquityIdentityToken,
                newToken.isEqual(oldToken) {
                return
            }

            // Account available and user switched, animate the spinner and reload the cache.
            //
            guard let menuVC = self.window?.rootViewController as? MenuViewController else { return }
            
            if let zoneNC = menuVC.menuViewController as? UINavigationController,
                let zoneViewController = zoneNC.viewControllers[0] as? ZoneViewController {
                zoneViewController.spinner.startAnimating()
            }
            
            if let mainNC = menuVC.mainViewController as? UINavigationController,
                let mainViewController = mainNC.viewControllers[0] as? MainViewController {
                mainViewController.spinner.startAnimating()
            }
            
            self.zoneCacheOrNil = ZoneLocalCache(self.container)
        }
    }
    
    func application(
        _ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        guard let zoneCache = zoneCacheOrNil else {
            fatalError("\(#function): zoneCache shouldn't be nil")
        }
        
        // When the app is transiting from background to foreground, appWillEnterForeground should have already
        // refreshed the local cache, so simply return when application.applicationState == .inactive.
        //
        guard let userInfo = userInfo as? [String: NSObject],
            application.applicationState != .inactive else { return }
        
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        // Only notifications with a subscriptionID are interested in this sample.
        //
        guard let subscriptionID = notification.subscriptionID else { return }
        
        // We use CKDatabaseSubscription to synchronize the changes. Note that it doesn't support the default zones.
        //
        if notification.notificationType == .database {
            for database in zoneCache.databases where database.cloudKitDB.name == subscriptionID {
                zoneCache.fetchChanges(from: database)
            }
        }
    }
    
    // Report the error when failed to register the notifications.
    //
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("!!! didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    // To be able to accept a share, add a CKSharingSupported entry in the info.plist and set it to true.
    // This is mentioned in the WWDC 2016 session 226 “What’s New with CloudKit”.
    //
    func application(_ application: UIApplication,
                     userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
        
        shareMetadataToOpen = cloudKitShareMetadata
        
        let acceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptSharesOperation.acceptSharesCompletionBlock = { error in
            guard handleCloudKitError(error, operation: .acceptShare, alert: true) == nil else { return }
        }
        container.add(acceptSharesOperation)
    }
}

extension AppDelegate { // MARK: - Account status checking.
    
    // Checking account availability. We do account check when the app comes back to foreground.
    // This method should be called from the main thread.
    //
    private func checkAccountStatus(for container: CKContainer,
                                    completionHandler: @escaping ((Bool) -> Void)) {
        
        var success = false, completed = false
        let task = {
            container.accountStatus { (status, error) in
                
                if handleCloudKitError(error, operation: .accountStatus, alert: true) == nil &&
                    status == CKAccountStatus.available {
                    success = true
                }
                completed = true
            }
        }
        
        // Do a second check a while (0.2 second) after the first failure.
        //
        let retryQueue = DispatchQueue(label: "retryQueue")
        let times = 2, interval = [0.0, 0.2]

        for index in 0..<times {
            retryQueue.asyncAfter(deadline: .now() + interval[index]) { task() }
            
            while completed == false {
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            }
            if success {
                break
            }
        }
        completionHandler(success)
    }
    
    private func handleAccountUnavailable() {
        
        let title = "iCloud account is unavailable."
        let message = "Be sure to sign in iCloud and turn on iCloud Drive before using this sample."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        window?.rootViewController?.present(alert, animated: true)

        // Clear the cache and post zoneCacheDidChange to upate the UI.
        // AppDelete.zoneCacheDidChange and try to load the first zone, which doesn't exist in this
        // case, thus triggers a .topicCacheDidChange to clear the topic UI.
        //
        zoneCacheOrNil = nil
        NotificationCenter.default.post(name: .zoneCacheDidChange, object: nil)
    }
}

// AppDelegate acts as the coordinator to manage the life cycle of the local cache.
// Refreshing topic cache when zonesDidChange happens; and refresh the UI when there is no cache at all.
//
extension AppDelegate { // MARK: - Local cache coordinator

    // Create a topic cache for the first zone, or return nil if there is no zone.
    //
    private func topicCacheForFirstZone() -> TopicLocalCache? {

        if let (database, zone) = zoneCacheOrNil?.firstZone() {
            return TopicLocalCache(container: container, database: database.cloudKitDB, zone: zone)
        }
        return nil
    }
    
    // The notification handler of .zoneCacheDidChange. Update the topic cache if it is stale.
    //
    @objc func zoneCacheDidChange(_ notification: Notification) {
        
        // If topicCache is nil, build it up with the first zone and set to self.topicCache,
        // TopicLocalCache.fetchChanges will trigger the UI update.
        // If the first zone doesn't even exist, post to clear the UI immediately.
        //
        guard let topicCache = topicCacheOrNil else {
            
            topicCacheOrNil = topicCacheForFirstZone()
            if topicCacheOrNil == nil {
                NotificationCenter.default.post(name: .topicCacheDidChange, object: nil)
            }
            return
        }
        
        // Now, topic cache is ready, grab the notification payload.
        //
        guard let zoneChanges = (notification.object as? ZoneCacheDidChange)?.payload else { return }
        
        // If there is a just-accpeted share, show it by switching to the zone
        //
        if zoneChanges.database.cloudKitDB.databaseScope == .shared,
            let zoneID = shareMetadataToOpen?.share.recordID.zoneID,
            let zone = zoneCacheOrNil?.zoneWithID(zoneID, scope: .shared),
            zoneChanges.zoneIDsChanged.contains(zoneID) {
            
            shareMetadataToOpen = nil
            
            let notificaitonObject = ZoneDidSwitch()
            notificaitonObject.payload = ZoneSwitched(database: zoneChanges.database, zone: zone)
            NotificationCenter.default.post(name: .zoneDidSwitch, object: notificaitonObject)
            
            return
        }
        
        // If the current zone was deleted, move to the first zone or clear the cache if no zone exists.
        // If topicCacheForFirstZone() returns nil because no first zone now,
        // use NotificationCenter.default to post .topicCacheDidChange to clear the UI immediately.
        //
        if zoneChanges.database.cloudKitDB.databaseScope == topicCache.database.databaseScope,
            zoneChanges.zoneIDsDeleted.contains(topicCache.zone.zoneID) {

            topicCacheOrNil = topicCacheForFirstZone()
            if topicCacheOrNil == nil {
                NotificationCenter.default.post(name: .topicCacheDidChange, object: nil)
            }
            return
        }

        // If the current zone was changed, then fetch the changes.
        //
        if zoneChanges.database.cloudKitDB.databaseScope == topicCache.database.databaseScope,
            zoneChanges.zoneIDsChanged.contains(topicCache.zone.zoneID) {
            
            topicCache.fetchChanges()
            return
        }
    }
    
    @objc func zoneDidSwitch(_ notification: Notification) {
        
        guard let payload = (notification.object as? ZoneDidSwitch)?.payload else {
            fatalError("\(#function): Wrong notification object!")
        }
        topicCacheOrNil = TopicLocalCache(container: container,
                                     database: payload.database.cloudKitDB,
                                     zone: payload.zone)
    }
}
