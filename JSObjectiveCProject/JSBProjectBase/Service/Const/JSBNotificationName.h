//
//  JSBNotificationName.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  项目全局可用的Notification Name
 */

@interface JSBNotificationName : NSObject

/**
 *  通知：用户登录成功
 */
UIKIT_EXTERN NSString *const JSBNotificationNameUserSignInSuccessful;

/**
 *  通知：用户登录失败
 */
UIKIT_EXTERN NSString *const JSBNotificationNameUserSignInFailure;

@end
