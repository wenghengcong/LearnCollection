//
//  RouterDispatchManager.h
//  iOSNotifications
//
//  Created by WengHengcong on 2018/3/8.
//  Copyright © 2018年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  协议处理完成block
 *
 *  @param className                协议处理类名
 *  @param resultInfo               协议处理后需要返回的结果信息
 */
typedef void(^RouterDispatchCompeletionBlock)(NSString *className, NSDictionary *resultInfo);

@interface JSMessageHandler : NSObject

/**
 注册类名和key映射关系

 @param className 自定义实现的类
 @param key 类名对应的key
 */
+ (void)registerClassName:(NSString *)className withKey:(NSString *)key;


/**
 需要在自定义实现的类中实现的方法

 @param userinfo 推送的userinfo
 @param compeletion 处理推送后需要返回的回调
 */
+ (void)handleRouterWithUserinfo:(NSDictionary *)userinfo compeletion:(RouterDispatchCompeletionBlock)compeletion;

@end
