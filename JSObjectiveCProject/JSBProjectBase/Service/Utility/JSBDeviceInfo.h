//
//  JSBDeviceInfo.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  主要方法：
*   1.是什么设备?
 *  2.设备系统版本
 *  3.设备尺寸、分辨率大小
 *  4.设备UI组件尺寸大小
 */

/**
 *  some usful information ^_^
 iPhone 6 Plus 736x414 points 2208x1242 pixels  3x scale  1920x1080 physical pixels  401 physical ppi   5.5"
 iPhone 6      667x375 points 1334x750 pixels   2x scale  1334x750 physical pixels   326 physical ppi   4.7"
 iPhone 5      568x320 points 1136x640 pixels   2x scale  1136x640 physical pixels   326 physical ppi   4.0"
 iPhone 4      480x320 points 960x640 pixels    2x scale  960x640 physical pixels    326 physical ppi   3.5"
 iPhone 3GS    480x320 points 480x320 pixels    1x scale  480x320 physical pixels    163 physical ppi   3.5"
 */

@interface JSBDeviceInfo : NSObject

#pragma mark - 什么设备

#define   iPhoneDevice          ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
#define   iPadDevice            ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )

+ (BOOL)isIPhone;
+ (BOOL)isIPad;

#pragma mark - 系统版本

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


+ (BOOL)isCurrentIOSVersionEqualToVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionGreaterThanVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionGreaterThanOrEqualToVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionLessThanVersion:(NSString *)iOSVersion;
+ (BOOL)isCurrentIOSVersionLessThanOrEqualToVersion:(NSString *)iOSVersion;

#define   lessIOS7          ( SYSTEM_VERSION_LESS_THAN(7.0) )
#define   IOS7              ( SYSTEM_VERSION_LESS_THAN(8.0) && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(7.0) )
#define   IOS8              ( SYSTEM_VERSION_LESS_THAN(9.0) && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(8.0) )
#define   IOS9              ( SYSTEM_VERSION_LESS_THAN(10.0) && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(9.0) )

+ (BOOL)isLessIOS7;
+ (BOOL)isIOS7;
+ (BOOL)isIOS8;
+ (BOOL)isIOS9;

#pragma mark - 设备屏幕

#define   iPhone4       ([JSBDeviceInfo screenHeight] < 568.0f)
#define   iPhone5       ([JSBDeviceInfo screenHeight] == 568.0f)
#define   iPhone6       ([JSBDeviceInfo screenHeight] == 667.0f)
#define   iPhone6P      ([JSBDeviceInfo screenHeight] == 736.0f)

#define   landscape         ( UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) )
#define   portrait          ( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )

+ (BOOL)isIPhone4;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6Plus;

+ (BOOL)isLandscape;
+ (BOOL)isPortrait;

#define     SWidth  ([[UIScreen mainScreen]bounds].size.width)
#define     SHeight  ([[UIScreen mainScreen]bounds].size.height)
#define     SResolution  ([[UIScreen mainScreen]scale])

#define     SNaviteWidth  ([[UIScreen mainScreen]nativeBounds].size.width)
#define     SNaviteHeight  ([[UIScreen mainScreen]nativeBounds].size.height)
#define     SNaviteResolution  ([[UIScreen mainScreen]nativeScale])

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (CGFloat)screenResolution;

+ (CGFloat)screenNaviteWidth;

+ (CGFloat)screenNaviteHeight;

+ (CGFloat)screenNaviteResolution;


#pragma mark - UI组件

@end
