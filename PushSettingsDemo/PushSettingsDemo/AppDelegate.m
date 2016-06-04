//
//  AppDelegate.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //极光推送
    [JPUSHService setupWithOption:launchOptions appKey:@"0d16cdd32fbdf6849b0a5214" channel:nil apsForProduction:NO];
    [JPUSHService registerForRemoteNotificationTypes:7 categories:nil];
    [JPUSHService setDebugMode];
    
    // Override point for customization after application launch.
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    }
    */
    
    //在app没有被启动的时候，接收到了消息通知。这时候操作系统会按照默认的方式来展现一个alert消息，在app icon上标记一个数字，甚至播放一段声音。
    
    //用户看到消息之后，点击了一下action按钮或者点击了应用图标。如果action按钮被点击了，系统会通过调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，并且会把notification的payload数据传递进去。如果应用图标被点击了，系统也一样会调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，唯一不同的是这时候启动参数里面不会有任何notification的信息。
    NSLog(@"*** push original info:%@",launchOptions);
    
    NSDictionary* remoteDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary* localDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //iOS8.0新增Today Widget
    NSURL * launchUrl              = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString * sourceApplicationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if (remoteDictionary != nil)
    {
        //处理app未启动的情况下，push跳转

    }
    
    // 本地消息
    else if (localDictionary != nil)
    {
        // 本地消息

    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Push Message Handler
/**
 *  This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
 *  ios8需要调用内容
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Calling this will result in either application:didRegisterForRemoteNotificationsWithDeviceToken: or application:didFailToRegisterForRemoteNotificationsWithError: to be called on the application delegate. Note: these callbacks will be made only if the application has successfully registered for user notifications with registerUserNotificationSettings:, or if it is enabled for Background App Refresh.
    [application registerForRemoteNotifications];
}

/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]])
        return;
    
    NSString * newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device token is: %@", newToken);
    
    //向服务器注册设备
    [JPUSHService registerDeviceToken:deviceToken];
}
/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"*** register failed.");
}

#pragma mark - action remote
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  8.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    
}

#pragma mark - action local
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  8.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
}
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler {

}

#pragma mark - local/remote handle

/**
 *  收到远程推送都会进入到这里
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"***push ***\n%@",userInfo);
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"App Background");

    }else {
        NSLog(@"App Foreground");

    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

}


@end
