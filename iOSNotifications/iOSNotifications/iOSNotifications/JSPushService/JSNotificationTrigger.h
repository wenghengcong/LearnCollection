//
//  JSNotificationTrigger.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * 通知触发方式实体类
 * 注：dateComponents、timeInterval、region在iOS10以上可选择其中一个参数传入有效值，如果同时传入值会根据优先级I、II、III使其中一种触发方式生效，fireDate为iOS10以下根据时间触发时须传入的参数
 */
@interface JSNotificationTrigger : NSObject<NSCopying,NSCoding>

/**
 设置是否重复，默认为NO
 */
@property (nonatomic, assign) BOOL repeat;

/**
 iOS8以上有效，用来设置触发通知的位置
 iOS10以上优先级为I，应用需要有允许使用定位的授权
 */
@property (nonatomic, copy) CLRegion    *region NS_AVAILABLE_IOS(8_0);

/**
 !!不建议使用！！
 仅作为兼容iOS 10以下
 iOS 10以下，用来设置触发通知的时间
 iOS 10以上，当dateComponents为空，会以该值作为触发时间
 */
@property (nonatomic, copy) NSDate      *fireDate   NS_DEPRECATED_IOS(2_0, 10_0 ,"Use dateComponents replace fireDate");

/**
 用来设置触发通知的日期时间
 iOS10以上有效，优先级为II
 */
@property (nonatomic, copy) NSDateComponents *dateComponents NS_AVAILABLE_IOS(10_0);

/**
 用来设置触发通知的时间
 iOS10以上有效，优先级为III
 */
@property (nonatomic, assign) NSTimeInterval timeInterval NS_AVAILABLE_IOS(10_0);

+ (instancetype)triggerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats;

+ (instancetype)triggerWithDateMatchingComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats;

+ (instancetype)triggerWithRegion:(CLRegion *)region repeats:(BOOL)repeats __WATCHOS_PROHIBITED;

@end

NS_ASSUME_NONNULL_END
