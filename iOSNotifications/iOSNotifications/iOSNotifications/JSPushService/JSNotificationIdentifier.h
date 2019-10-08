//
//  JSNotificationIdentifier.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//
#import "JSPushUtilities.h"

NS_ASSUME_NONNULL_BEGIN
/**
 通知的推送状态

 - JSPushNotificationStateAll: 包括pending与delivered
 - JSPushNotificationStatePending: 待推送的通知
 - JSPushNotificationStateDelivered: 已经推送的通知
 */
typedef NS_ENUM(NSUInteger, JSPushNotificationState) {
    JSPushNotificationStateAll,
    JSPushNotificationStatePending,
    JSPushNotificationStateDelivered,
};

@interface JSNotificationIdentifier : NSObject<NSCopying,NSCoding>

/**
 通知的标识数组
 适用与查找与移除通知
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *identifiers;

/**
 iOS 以下仅用于移除通知
 iOS 10以下，设置notificationObj和identifiers，notificationObj优先级更高
 */
@property (nonatomic, copy ,nullable) UILocalNotification *notificationObj    NS_DEPRECATED_IOS(4_0, 10_0 , "Use UserNotifications Framework's UNNotificationRequest");

/**
 标志需要查找或者移除通知的通知状态
 仅支持iOS 10以上
 */
@property (nonatomic ,assign) JSPushNotificationState   state  NS_AVAILABLE_IOS(10_0);

/**
 用于查询回调，调用[findNotification:]方法前必须设置
 results为返回相应对象数组
 iOS10以下：返回UILocalNotification对象数组；
 iOS10以上：根据state传入值返回UNNotification或UNNotificationRequest对象数组
 */
@property (nonatomic, copy ,nullable) void (^findCompletionHandler)(NSArray * __nullable results);


/**
 iOS 10 以下，移除UILocalNotification可通过该方法创建
 */
+ (instancetype)identifireWithNnotificationObj:(UILocalNotification *)noti NS_DEPRECATED_IOS(4_0, 10_0 , "Use UserNotifications Framework's");

/**
 移除identifiers对应通知，可通过该方法创建
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers;


/**
 iOS 10以上用于查找或移除
 @param identifiers 查找或移除的id
 @param state 对应通知的状态
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state;

/**
 iOS 10以上查找，可通过该方法创建
 如果是移除，findCompletionHandler为nil即可
 */
+ (instancetype)identifireWithIdentifiers:(NSArray <NSString *> *)identifiers  state:(JSPushNotificationState)state withFindCompletionHandler:(void(^)(NSArray * __nullable results))findCompletionHandler;


@end
NS_ASSUME_NONNULL_END
