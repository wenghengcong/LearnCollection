//
//  AppDelegate.m
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "AppDelegate.h"
#import "JSPushService.h"
#import "PushTestingController.h"
#import "JSMessageHandler.h"
#import "PushSettingsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //the data store by host app, read by notification service extension
    //go to NotificationService target to check the shared dta
    NSUserDefaults *groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bfpushtest"];
    [groupDefault setObject:@"Between Host App And Extension" forKey:@"JSSharedData"];
    [groupDefault synchronize];
    
    NSString *shared = [groupDefault objectForKey:@"JSSharedData"];
    NSLog(@"shared data: %@", shared);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self wirteLogWithString:@"****************************************************"];
    [self wirteLogWithString:@"iOSNoti:didFinishLaunchingWithOptions."];
    [PushTestingController setupWithOption:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self wirteLogWithString:@"iOSNoti:applicationDidBecomeActive."];
    //重置角标
//    [JSPushService resetBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self wirteLogWithString:@"iOSNoti:applicationDidEnterBackground."];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self wirteLogWithString:@"iOSNoti:applicationWillEnterForeground."];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self wirteLogWithString:@"iOSNoti:applicationWillTerminate."];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self wirteLogWithString:@"iOSNoti:applicationDidReceiveMemoryWarning."];
}

#pragma mark - Push Message Handler
/**
 *  This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
 *  iOS8后需要支持
 *  根据我们提供的注册通知类型，就是UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge
 *  以及用户在“设置”中开关的值做比较。
 *  来决定本地和远程支持的类型。
 *  其中在第二个参数的notificationSettings是“设置”中的值。
 *
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [self wirteLogWithString:@"iOSNoti:didRegisterUserNotificationSettings."];
    // Calling this will result in either application:didRegisterForRemoteNotificationsWithDeviceToken: or application:didFailToRegisterForRemoteNotificationsWithError: to be called on the application delegate. Note: these callbacks will be made only if the application has successfully registered for user notifications with registerUserNotificationSettings:, or if it is enabled for Background App Refresh.
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        //registerForRemoteNotifications方法调用后会application:didRegisterForRemoteNotificationsWithDeviceToken或application:didFailToRegisterForRemoteNotificationsWithError
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

#pragma mark - 唯二不在UserNotifications框架内的API
/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [JSPushService registerDeviceToken:deviceToken completionHandler:^(NSString *devicetoken) {
       //将devicetoken传给你的服务器或者保存
        NSString *devt = [NSString stringWithFormat:@"iOSNoti:device token:%@",devicetoken];
        [self wirteLogWithString:devt];
    }];
}
/**
 *  registerForRemoteNotifications的回调
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [self wirteLogWithString:@"iOSNoti:register failed."];
}

#pragma mark - action remote
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  8.0 above
 *  当操作交互式通知时，进入这里
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [self wirteLogWithString:@"iOSNoti:handleActionWithIdentifier forRemoteNotification completionHandler"];
    //handle the actions
    if ([identifier isEqualToString:@"acceptAction"]){
    }
    else if ([identifier isEqualToString:@"rejectAction"]){
    }
     //注意调用该函数！！！！
    completionHandler();
}
/**
 *  Called when your app has been activated by the user selecting an action from a remote notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    [self wirteLogWithString:@"iOSNoti:handleActionWithIdentifier forRemoteNotification withResponseInfo completionHandler"];
    //注意调用该函数！！！！
    completionHandler();
}


#pragma mark - action local
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  8.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    [self wirteLogWithString:@"iOSNoti:handleActionWithIdentifier forLocalNotification completionHandler"];
    //注意调用该函数！！！！
    completionHandler();
}
/**
 *  Called when your app has been activated by the user selecting an action from a local notification.
 *  9.0 above
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler {
    
    [self wirteLogWithString:@"iOSNoti:handleActionWithIdentifier forLocalNotification withResponseInfo completionHandler"];
    //注意调用该函数！！！！
    completionHandler();
}

#pragma mark - local/remote handle
/**
 * iOS 10之前，在前台，收到本地通知，会进入这里
 * iOS 10之前，在后台，点击本地通知，会进入这里
 * 假如未设置UNUserNotificationCenter代理，iOS 10收到本地通知也会进入这里。
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *not = [NSString stringWithFormat:@"iOSNoti:didReceiveLocalNotification %@",notification.userInfo];
    
    [self wirteLogWithString:not];
}

/**
 *  iOS 10之前，若未实现该代理application didReceiveRemoteNotification: fetchCompletionHandler:
 不管在前台还是在后台，收到远程通知（包括静默通知）会进入didReceiveRemoteNotification代理方法；
 *  假如实现了，收到远程通知（包括静默通知）就会进入application didReceiveRemoteNotification: fetchCompletionHandler:方法
 *  假如未设置UNUserNotificationCenter代理，iOS 10收到远程通知也会进入这里。
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSString *not = [NSString stringWithFormat:@"iOSNoti:didReceiveRemoteNotification %@",userInfo];
    
    [self wirteLogWithString:not];
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
/**
 *  iOS 10之前，不管在前台还是在后台，收到远程通知会进入此处；
 *  iOS 10之前，若未实现该代理，不管在前台还是在后台，收到远程通知会进入didReceiveRemoteNotification代理方法；
 *  iOS 10之前，静默通知，会进入到这里；
 *  iOS 10之后，在前台，静默通知，也会进入到这里
        如果为设置代理，再调用- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler。
        否则，不会调用上面方法；
 *  iOS 10之后，在后台，收到静默推送，也会进到这里。
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JSMessageHandler handleRouterWithUserinfo:userInfo compeletion:^(NSString *className, NSDictionary *resultInfo) {
        NSLog(@"class:%@-userin:%@", className, resultInfo);
    }];
    
    NSString *userInfoStr = [NSString stringWithFormat:@"iOSNoti:didReceiveRemoteNotification fetchCompletionHandler %@",userInfo];
    
    [self wirteLogWithString:userInfoStr];
    NSString * alertTitle = @"";
    if (userInfo[@"aps"] != nil && userInfo[@"aps"][@"alert"] != nil && [userInfo[@"aps"][@"alert"] isKindOfClass:[NSDictionary class]]) {
        alertTitle = userInfo[@"aps"][@"alert"][@"body"];

    } else if (userInfo[@"aps"] != nil && userInfo[@"aps"][@"alert"] != nil && [userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        alertTitle = userInfo[@"aps"][@"alert"];
    }
    if (alertTitle == nil || [alertTitle length] == 0) {
        alertTitle = @"收到远程推送";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:@"iOS 10以下系统，显示通知弹窗" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}

# pragma mark iOS 10

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
// 会屏蔽iOS10之前方法（设置对应的代理后）

/**
 *  在前台如何处理，通过completionHandler指定。如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
 // completionHandler(0)
 *  前台收到远程通知，进入这里
 *  前台收到本地通知，进入这里
 *  前台收到带有其他字段alert/sound/badge的静默通知，进入这里
 *  后台收到静默通知不会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    [self wirteLogWithString:@"iOSNoti:iOSNoti:userNotificationCenter willPresentNotification"];

    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
    //远程通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self wirteLogWithString:@"iOSNoti:push"];
    }else{
        // 判断为本地通知
        NSString *log = [NSString stringWithFormat:@"iOSNoti:iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo];
        
        [self wirteLogWithString:log];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


/**
 * 在用户与你通知的通知进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个action
 * 后台收到远程通知，点击进入
 * 后台收到本地通知，点击进入
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    [self wirteLogWithString:@"iOSNoti:userNotificationCenter didReceiveNotificationResponse"];
    /*
    >UNNotificationResponse
        >NSString *actionIdentifier
        >UNNotification *notification
            >NSDate *date
            >UNNotificationRequest *request
                >NSString *identifier
                >UNNotificationTrigger *trigger
                >UNNotificationContent *content
                    >NSNumber *badge
                    >NSString *body
                    >NSString *categoryIdentifier
                    >NSString *launchImageName
                    >NSString *subtitle
                    >NSString *title
                    >NSString *threadIdentifier
                    >UNNotificationSound *sound
                    >NSArray <UNNotificationAttachment *> *attachments
                    >NSDictionary *userInfo
     */
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
    //远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
        {
            
        }else if ([actionIdentifier isEqualToString:@"inputAction"]){
            
            if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                
                NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                NSString *log = [NSString stringWithFormat:@"iOSNoti:%@",inputText];
                
                [self wirteLogWithString:log];
            }
            
        } else if ([actionIdentifier isEqualToString:@"goodDetailAction"]) {
            //跳转到商品详情页面
            NSLog(@"go to product detail page");
        }
    }else{
        // 判断为本地通知
        NSString *log = [NSString stringWithFormat:@"iOSNoti:iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo];
        
        [self wirteLogWithString:log];
        
        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
        {
            
        }else if ([actionIdentifier isEqualToString:@"inputAction"]){
            
            if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                
                NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                NSString *log = [NSString stringWithFormat:@"iOSNoti:%@",inputText];
                
                [self wirteLogWithString:log];
            }
            
        }
        
    }
    
    completionHandler();
}

#endif


#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification
{
    PushSettingsViewController *pushVc = [[PushSettingsViewController alloc] init];
    UINavigationController *nav = [UIApplication sharedApplication].delegate.window.rootViewController;
    [nav pushViewController:pushVc animated:YES];
}

#endif

# pragma mark - Log

- (void)wirteLogWithString:(NSString *)loginput
{
    NSLog(@"%@",loginput);
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"MessageLog.txt"];
    
    if (![fm fileExistsAtPath:fileName]) {
        NSString *str = @"测试数据\n";
        [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [fileHandle seekToEndOfFile];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSString *logDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *logLine = [NSString stringWithFormat:@"\n%@-%@",loginput,logDate];
    
    NSData *logData = [logLine dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:logData];
        
}
@end
