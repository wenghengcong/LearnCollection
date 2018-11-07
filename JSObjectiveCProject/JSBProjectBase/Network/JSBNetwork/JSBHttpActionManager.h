//
//  JSBHttpActionManager.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSBHttpActionManager : NSObject

+ (id)sharedManager;

/**
 *  获得http请求操作管理器
 */
- (AFHTTPRequestOperationManager *) getHttpRequestMgr;

- (void) clearCookies;

@end
