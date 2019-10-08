//
//  JSRegisterConfig.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/26.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//
#import "JSPushUtilities.h"
/**
 通知注册实体类
 */
@interface JSRegisterConfig : NSObject

/**
 通知支持的类型
 badge,sound,alert
 */
@property (nonatomic, assign) NSInteger types;

/**
 通知类别
 iOS10 UNNotificationCategory
 iOS8-iOS9 UIUserNotificationCategory
 */
@property (nonatomic, strong) NSSet *categories;

@end
