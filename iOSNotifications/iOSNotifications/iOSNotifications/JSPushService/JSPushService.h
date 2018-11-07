//
//  NewPushManager.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushUtilities.h"
#import "JSServiceDelegate.h"
#import "JSRegisterConfig.h"
#import "JSNotificationIdentifier.h"
#import "JSNotificationContent.h"
#import "JSNotificationTrigger.h"
#import "JSNotificationRequest.h"

UIKIT_EXTERN NSString *const JSPUSHSERVICE_LOCALNOTI_IDENTIFIER;

@interface JSPushService : NSObject

/**
 单例对象
 */
+ (instancetype)sharedManager;

/**
 代理
 */
@property (nonatomic,weak)id<JSServiceDelegate> delegate;

/**
 注册远程通知

 @param types 注册类型0~7  typs是由三位二进制位构成的，Alert|Sound|Badge
 @param categories 通知分类
 */
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories;

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
/**
 注册通知，并且设置处理通知的代理

 @param config 注册通知配置，包括注册通知类别以及通知展示类型
 @param delegate 处理通知代理
 */
+ (void)registerForRemoteNotificationConfig:(JSRegisterConfig *)config delegate:(id<JSServiceDelegate>)delegate;
#endif
/**
 获取device token
 需要在该方法中奖token发送至你的服务器
 
 @param deviceToken 从APNS中获取到的device token
 */
+ (void)registerDeviceToken:(NSData*)deviceToken completionHandler:(void (^)(NSString *devicetoken))completionHandler;

#pragma makr - Notification

/**
 注册或更新通知(支持iOS10，并兼容iOS10以下版本)

 @param jsRequest JPushNotificationRequest类型。
    设置通知的属性，设置已有通知的request.requestIdentifier即更新已有的通知，否则为注册新通知。
    更新通知仅仅在iOS10以上有效，结果通过request.completionHandler返回
 */
+ (void)addNotification:(JSNotificationRequest *)jsRequest;

/**
 移除通知(支持iOS10，并兼容iOS10以下版本)

 @param identifier JSNotificationIdentifier类型
 
    iOS10以上：
        优先级1：identifier为nil，则移除所有在通知中心已显示通知和待通知请求；
        优先级2：identifier.identifiers如果设置为nil或空数组，移除identifier.state相应标志下所有通知请求；
        优先级3：设置identifier.state和identifier.identifiers，移除identifier.state相应标志下的多条通知；
 
    iOS10以下：移除通知只针对本地通知
        优先级1：identifier.notificationObj传入特定通知对象，移除单条通知；
        优先级3：identifier设置为nil,identifier.identifiers为nil或为空数组，移除所有通知；
        优先级4：identifier.identifiers有效数组，移除多条通知；

 */
+ (void)removeNotification:(JSNotificationIdentifier *)identifier;

/**
 查找通知(支持iOS10，并兼容iOS10以下版本)
 @param identifier JSNotificationIdentifier类型
 
    必现设置identifier.findCompletionHandler回调才能得到查找结果，通过(NSArray *results)返回相应对象数组。
    iOS10以上：
        设置identifier.state和identifier.identifiers来查找相应标志下通知请求，identifier.identifiers如果设置为nil或空数组则返回相应标志下所有通知请求；
    iOS10以下：
        identifier.state属性无效;
        identifier.identifiers如果设置nil或空数组则，返回所有通知。
 */
+ (void)findNotification:(JSNotificationIdentifier *)identifier;

#pragma mark - Badge

/*

 应用角标
 
 1.假如本地通知和远程通知的消息payload都不带有badge字段，那么不管角标如何设置。
 *点击通知，点击一条消除一条；
 *点击APP，通知不会消除；
 2.如何本地通知或远程通知中含有payload带有badge字段，
 * 假如角标设为“当前角标-1”，且不为0，通知点击一条消除一条，点击主应用，通知中心通知不改变；
 * 假如角标设为0，不管点击通知，还是点击应用，那么通知会全部清除。
 
 */
/**
 *  设置应用角标
 */
+ (void)setBadge:(NSInteger)badge;
/**
 *  重置应用角标(为0)
 */
+ (void)resetBadge;

#pragma mark - Others
/**
 判断所截获的通知对象是否通过JSPushService创建
 
 @param usernotication 对象类包括：UILocalNotification、UNNotificationResponse、UNNotification
 */
+ (BOOL)isFromJSPushService:(id)usernotication;

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
/**
 根据对象获取其中的UNNotification对象
 
 @param obj 包括UNNotificationResponse、UNNotification类对象
 @return 返回obj中的UNNotification对象，假如类型不对返回nil
 */
+ (UNNotification *)getUNNotification:(id)obj;
#endif

@end
