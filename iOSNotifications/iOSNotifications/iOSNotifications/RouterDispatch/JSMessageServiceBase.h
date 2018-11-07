//
//  PushHandle.h
//  iOSNotifications
//
//  Created by WengHengcong on 2018/3/8.
//  Copyright © 2018年 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSMessageHandler.h"

@interface JSMessageServiceBase : NSObject


/**
 消息处理

 @param userinfo 消息内容
 */
- (void)jsMessageOpenServiceWithUserinfo:(NSDictionary *)userinfo;

@end
