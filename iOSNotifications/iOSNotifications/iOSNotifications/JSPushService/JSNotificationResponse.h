//
//  JSNotificationResponse.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/26.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//
#import "JSPushUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNotificationResponse : NSObject<NSCopying>

// The notification to which the user responded.
@property (NS_NONATOMIC_IOSONLY, readonly, copy) UNNotification *notification;

// The action identifier that the user chose:
// * UNNotificationDismissActionIdentifier if the user dismissed the notification
// * UNNotificationDefaultActionIdentifier if the user opened the application from the notification
// * the identifier for a registered UNNotificationAction for other actions
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *actionIdentifier;

@end

NS_ASSUME_NONNULL_END
