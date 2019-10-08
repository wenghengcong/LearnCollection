//
//  AppDelegate.h
//  iOSNotifications
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define appDelegate		((AppDelegate *)[[UIApplication sharedApplication] delegate])

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
#else
@interface AppDelegate : UIResponder <UIApplicationDelegate>
#endif

@property (strong, nonatomic) UIWindow *window;


- (void)wirteLogWithString:(NSString *)loginput;

@end
