//
//  JSBDeviceInfo.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBDeviceInfo.h"

@implementation JSBDeviceInfo

#pragma mark - 系统版本

#pragma mark - 什么设备

+ (BOOL)isIPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isIPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isCurrentIOSVersionEqualToVersion:(NSString *)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] compare:iOSVersion options:NSNumericSearch] == NSOrderedSame;
}

+ (BOOL)isCurrentIOSVersionGreaterThanVersion:(NSString *)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] compare:iOSVersion options:NSNumericSearch] == NSOrderedDescending;
}

+ (BOOL)isCurrentIOSVersionGreaterThanOrEqualToVersion:(NSString *)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] compare:iOSVersion options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL)isCurrentIOSVersionLessThanVersion:(NSString *)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] compare:iOSVersion options:NSNumericSearch] == NSOrderedAscending;
}

+ (BOOL)isCurrentIOSVersionLessThanOrEqualToVersion:(NSString *)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] compare:iOSVersion options:NSNumericSearch] != NSOrderedDescending;
}

+ (BOOL)isLessIOS7 {
    return ([JSBDeviceInfo isCurrentIOSVersionLessThanVersion:@"7.0"]);
}

+ (BOOL)isIOS7 {
    return ([JSBDeviceInfo isCurrentIOSVersionLessThanVersion:@"8.0"])&&([JSBDeviceInfo isCurrentIOSVersionGreaterThanOrEqualToVersion:@"7.0"]);
}

+ (BOOL)isIOS8 {
    return ([JSBDeviceInfo isCurrentIOSVersionLessThanVersion:@"9.0"])&&([JSBDeviceInfo isCurrentIOSVersionGreaterThanOrEqualToVersion:@"8.0"]);
}

+ (BOOL)isIOS9 {
    return ([JSBDeviceInfo isCurrentIOSVersionLessThanVersion:@"10.0"])&&([JSBDeviceInfo isCurrentIOSVersionGreaterThanOrEqualToVersion:@"9.0"]);
}

#pragma mark - 设备屏幕

+ (BOOL)isIPhone4
{
    return [JSBDeviceInfo screenHeight] < 568.0f;
}
+ (BOOL)isIPhone5
{
    return [JSBDeviceInfo screenHeight] == 568.0f;
}
+ (BOOL)isIPhone6
{
    return [JSBDeviceInfo screenHeight] == 667.0f;
}
+ (BOOL)isIPhone6Plus
{
    return [JSBDeviceInfo screenHeight] == 736.0f;
}

+ (BOOL)isLandscape
{
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
}
+ (BOOL)isPortrait
{
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation);
}

+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen]bounds].size.width;
}

+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen]bounds].size.height;
}

+ (CGFloat)screenResolution
{
    return [[UIScreen mainScreen]scale];
}

+ (CGFloat)screenNaviteWidth
{
    return [[UIScreen mainScreen]nativeBounds].size.width;
}

+ (CGFloat)screenNaviteHeight
{
    return [[UIScreen mainScreen]nativeBounds].size.height;
}

+ (CGFloat)screenNaviteResolution
{
    return [[UIScreen mainScreen]nativeScale];
}

@end
