//
//  JSBProjectInfo.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  获取当前项目信息
 * 
 * 
 *  
 */
@interface JSBProjectInfo : NSObject
/**
 *  获取app info.plist的信息
 */
+ (NSDictionary *) appInfo;
+ (NSString *)appDisplayName;
+ (NSString *)executeable;
+ (NSString *)bundleIdentifier;
+ (float)shortVersion;
+ (float)buildVersion;

@end
