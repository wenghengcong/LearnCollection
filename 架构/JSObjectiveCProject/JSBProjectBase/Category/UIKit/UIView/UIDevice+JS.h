//
//  UIDevice+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/6/6.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS"
#define IPHONE_4_NAMESTRING				@"iPhone4"
#define IPHONE_4s_NAMESTRING			@"iPhone4s"
#define IPHONE_5_NAMESTRING				@"iPhone5"
#define IPHONE_5c_NAMESTRING			@"iPhone5c"
#define IPHONE_5s_NAMESTRING			@"iPhone5s"
#define IPHONE_6_NAMESTRING			@"iPhone6"
#define IPHONE_6_P_NAMESTRING			@"iPhone6 Plus"
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_5G_NAMESTRING				@"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad1"
#define IPAD_2G_NAMESTRING				@"iPad2"
#define IPAD_3G_NAMESTRING				@"iPad3"
#define IPAD_4G_NAMESTRING				@"iPad4"
#define IPAD_Air_NAMESTRING				@"iPad Air"
#define IPAD_Air2_NAMESTRING			@"iPad Air 2"
#define IPAD_Mini_NAMESTRING			@"iPad mini"
#define IPAD_Mini2_NAMESTRING			@"iPad mini 2"
#define IPAD_Mini3_NAMESTRING			@"iPad mini 3"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"
#define APPLETV_3G_NAMESTRING			@"Apple TV 3G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4siPhone,
    UIDevice5iPhone,
    UIDevice5cPhone,
    UIDevice5siPhone,
    UIDevice6iPhone,
    UIDevice6PiPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    
    UIDevice1GiPad, // both regular and 3G
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    UIDeviceAirGiPad,
    UIDeviceAir2GiPad,
    UIDeviceiPadMini,
    UIDeviceiPadMini2,
    UIDeviceiPadMini3,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    
} UIDevicePlatform;


@interface UIDevice(JS)

#pragma mark- hardware

+ (NSString *) platform;
+ (NSString *) hwmodel;
+ (NSUInteger) platformType;
+ (NSString *) platformString;
+ (NSString *) platformCode;

+ (NSUInteger) cpuFrequency;
+ (NSUInteger) busFrequency;
+ (NSUInteger) totalMemory;
+ (NSUInteger) userMemory;

+ (NSNumber *) totalDiskSpace;
+ (NSNumber *) freeDiskSpace;

+ (NSString *) macaddress;
/// 获取iOS系统的版本号
+ (NSString *)systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)hasCamera;

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

+ (NSString *) uniqueDeviceIdentifier;
+ (BOOL)isIOS8;
+ (BOOL)isIOS7;
+ (BOOL)isMCOK;
+ (BOOL)isIphone5;
+ (BOOL)isiPhone6;
+ (BOOL)isiPhone6P;
+ (float)mathiPhoneType:(float)f;
/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;
- (BOOL)isJailbroken;


#pragma mark- screen resolution

+ (float)pointsPerCentimeter;
+ (float)pixelsPerCentimeter;

+ (float)pointsPerInch;
+ (float)pixelsPerInch;


@end
