/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This sample's application delegate for push notiications (CKSubscriptions) from CloudKit.
 */

@import UserNotifications;

#import "AppDelegate.h"
#import "APLMainTableViewController.h"
#import "APLCloudManager.h"
#import "CloudPhoto.h"

@interface AppDelegate () <APLCloudManagerDelegate>
@end

@implementation AppDelegate

// The app delegate must implement the window @property
// from UIApplicationDelegate @protocol to use a main storyboard file.
//
@synthesize window;

#pragma mark - Application Life Cycle

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // for the sake of UIStateRestoration (we restore early in the launch process)
        // and
        // APLMainTableViewController may be loaded before we have a chance to setup our CloudManager object so create it earlier here
        //
        CloudManager.delegate = self;   // we want to be notified by our CloudManager when the user logs in or out
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register for push notifications (from CloudKit)
    // Necessary to receive local or remove notifications.
    //
    // Note: This will not work in the simulator.
    //
    // Note: Without registering, sound and badging won't show up for your app in: Settings -> Notifications -> <this app>,
    //       and you won't have permission to badge or show alerts.
    //
    // User permissions can later be adjusted in Settings -> Notifications -> <this app>
    //

    // To reset the Push Notifications Permissions Alert on iOS:
    //    1. Delete your app from the device.
    //    2. Turn the device off completely and turn it back on.
    //    3. Go to Settings > General > Date & Time: and set the date ahead a day or more.
    //    4. Turn the device off completely again and turn it back on.
    //    5. You can then set date and time setting to automatic.
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
        {
            // start the request for authorization
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error != nil)
                {
                    NSLog(@"ERROR in request authorization = %@", error);
                }
                else if (granted)
                {
                    // we are good to receive user notifications
                }
            }];
        }
        else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
        {
            // we are good to receive notifications
        }
        else if (settings.authorizationStatus == UNAuthorizationStatusDenied)
        {
            // notications are disabled for this app
        }
        
    }];
    
    [application registerForRemoteNotifications];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSLog(@"CloudPhotos: Registered for Push notifications with token: %@\n", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"CloudPhotos: Push subscription failed\n%@", error);
}


#pragma mark - Accessors

- (APLMainTableViewController *)mainViewController
{
    UINavigationController *rootVC = (UINavigationController *)self.window.rootViewController;
    return (APLMainTableViewController *)rootVC.viewControllers[0];
}


#pragma mark - Push Notifications

// attempt to find the owner of that recordID from this CKQueryNotification and report it (for debugging purposes)
//
- (void)reportUserFromNotification:(CKQueryNotification *)queryNotification
{
    CKRecordID *recordID = [queryNotification recordID];
    
    // note you can't create a CKRecord from a CKQueryNotification, so we need to do a lookup instead
    [CloudManager fetchRecordWithID:recordID completionHandler:^(CKRecord *foundRecord, NSError *error) {
        
        if (foundRecord != nil)
        {
            // find out the user who affected this record
            CloudPhoto *pertainingPhoto = [[CloudPhoto alloc] initWithRecord:foundRecord];
            [pertainingPhoto photoOwner:^(NSString *owner) {
                
                // we are only interested in the kPhotoTitle attribute
                //  (because we set the CKSubscription's CKNotificationInfo 'desiredKeys' when we subscribed earlier)
                NSDictionary *recordFields = [queryNotification recordFields];
                NSString *photoTitle = recordFields[[APLCloudManager PhotoTitleAttribute]];
                
                // here we can examine the title of the photo record without a query
                CKQueryNotificationReason reason = [queryNotification queryNotificationReason];
                NSString *baseMessage = nil;
                switch (reason)
                {
                    case CKQueryNotificationReasonRecordCreated:
                        baseMessage = NSLocalizedString(@"Photo Added Notif Message", nil);
                        break;
                        
                    case CKQueryNotificationReasonRecordUpdated:
                        baseMessage = NSLocalizedString(@"Photo Changed Notif Message", nil);
                        break;
                        
                    case CKQueryNotificationReasonRecordDeleted:
                        baseMessage = NSLocalizedString(@"Photo Removed Notif Message", nil);
                        break;
                }
                if (baseMessage != nil)
                {
                    NSString *message = [NSString stringWithFormat:baseMessage, photoTitle, owner];
                    NSLog(@"%@", message);
                }
             }];
        }
    }];
}

// didReceiveRemoteNotification:
//
// This is called when:
// 1) the app is actively running (no push alert will appear)
// or
// 2) the app is in the background (push banner will appear, user taps the banner to open our app)
//
// To receive background notifications, this has to be turned on in Xcode:
//      Capabilities -> Background Modes: Remote Notifications
//          where this is added to the Info.plist as a result:
//              	<key>UIBackgroundModes</key>
//                  <array>
//                  <string>remote-notification</string>
//                  </array>
//
// Note #1:
// The system calls this method when your app is running in the foreground OR background.
// We have up to 30 seconds of wall-clock time to process the notification and call the specified completion handler block.
// So we need to start a background task to process any or all notificiations.
//
// Note #2:
// To test of the app was actually relaunched due to the push receive,
// use Instrument's Activity Monitor to test if it was truly launched (by checking the "running processes" for that device).
//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        //NSLog(@"incoming push notification: app is active");
    }
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        //NSLog(@"incoming push notification: app is the background");
    }
    
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
    // When a silent notification arrives, iOS wakes up your app in the background so that you can get new data from
    // your server or do background information processing. Users aren’t told about the new or changed information
    // that results from a silent notification, but they can find out about it the next time they open your app.
    //
    // NOTE:
    // If the notification has 1) alert, 2) badge, or 3) soundKey, then CloudKit uses priority 10, otherwise is uses 5.
    //
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // on a secondary thread process our incoming push notifications
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // all incoming push notifications are handled inside our CloudManager object,
        // view controllers of this app will be called via NSNotificationCenter to update their UI
        //
        [CloudManager processNotifications];
        
        completionHandler(UIBackgroundFetchResultNewData);
        
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}


#pragma mark - UIStateRestoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}


#pragma mark - APLCloudManagerDelegate

// the user signed in or out of iCloud so we need to refresh our UI
- (void)userLoginChanged
{
    // notify the main table of the login change, to give it chance to refresh its UI
    APLMainTableViewController *mainTableViewController = [self mainViewController];
    [mainTableViewController loginUpdate];
    
    UINavigationController *rootVC = (UINavigationController *)self.window.rootViewController;
    UIViewController *currentViewController = rootVC.visibleViewController;
    if ([currentViewController isKindOfClass:[APLDetailTableViewController class]])
    {
        [(APLDetailTableViewController *)currentViewController loginUpdate];
    }
}

@end
