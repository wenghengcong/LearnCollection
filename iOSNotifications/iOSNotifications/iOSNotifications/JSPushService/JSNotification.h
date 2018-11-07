//
//  JSNotification.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/26.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSPushUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSNotification : NSObject<NSCopying>

// The date displayed on the notification.
@property (nonatomic, readonly, copy) NSDate *date;

// The notification request that caused the notification to be delivered.
@property (nonatomic, readonly, copy) UNNotificationRequest *request;

@end
NS_ASSUME_NONNULL_END
