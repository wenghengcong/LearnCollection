//
//  ServiceOne.m
//  LoadMethod
//
//  Created by WengHengcong on 2018/3/8.
//  Copyright © 2018年 LuCi. All rights reserved.
//

#import "ServiceOne.h"

@implementation ServiceOne

/**
 在load方法中注册当前Service与key的对应关系
 */
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JSMessageHandler registerClassName:NSStringFromClass([self class]) withKey:@"serviceOne"];
    });
}

/**
 自定义Service 消息处理

 @param userinfo 推送的userinfo
 */
- (void)jsMessageOpenServiceWithUserinfo:(NSDictionary *)userinfo
{
    NSLog(@"hanlde service one");
}

@end
