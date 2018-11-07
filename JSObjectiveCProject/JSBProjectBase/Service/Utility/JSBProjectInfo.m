//
//  JSBProjectInfo.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBProjectInfo.h"

#pragma mark - Info Plist 信息
/*************************************************************************
 *************************  Info plist 信息
 *************************************************************************
 */

/**
 BuildMachineOSBuild = 15C50;
 CFBundleDevelopmentRegion = en;
 CFBundleExecutable = JSBProjectBase;
 CFBundleIdentifier = "com.junglesong.JSBProjectBase";
 CFBundleInfoDictionaryVersion = "6.0";
 CFBundleInfoPlistURL = "Info.plist -- file:///Users/WHC/Library/Developer/CoreSimulator/Devices/E27D96BE-1B1A-45AC-B8B7-C889B527B323/data/Containers/Bundle/Application/62484A10-917E-422A-98B2-207D71C817B5/JSBProjectBase.app/";
 CFBundleName = JSBProjectBase;
 CFBundleNumericVersion = 16809984;
 CFBundlePackageType = APPL;
 CFBundleShortVersionString = "1.0";
 CFBundleSignature = "????";
 CFBundleSupportedPlatforms =     (
 iPhoneSimulator
 );
 CFBundleVersion = 1;
 DTCompiler = "com.apple.compilers.llvm.clang.1_0";
 DTPlatformBuild = "";
 DTPlatformName = iphonesimulator;
 DTPlatformVersion = "9.2";
 DTSDKBuild = 13C75;
 DTSDKName = "iphonesimulator9.2";
 DTXcode = 0720;
 DTXcodeBuild = 7C68;
 LSRequiresIPhoneOS = 1;
 MinimumOSVersion = "7.0";
 UIAppFonts =     (
 "Omnes_Light.ttf",
 "Omnes_Medium.ttf"
 );
 UIDeviceFamily =     (
 1
 );
 UILaunchStoryboardName = LaunchScreen;
 UIMainStoryboardFile = Main;
 UIRequiredDeviceCapabilities =     (
 armv7
 );
 UISupportedInterfaceOrientations =     (
 UIInterfaceOrientationPortrait,
 UIInterfaceOrientationLandscapeLeft,
 UIInterfaceOrientationLandscapeRight
 );

 */

@implementation JSBProjectInfo


+ (NSDictionary *) appInfo {
    return [NSBundle mainBundle].infoDictionary;
}

+ (NSString *)appDisplayName {
    return [JSBProjectInfo appInfo][@"CFBundleDisplayName"];
}

+ (NSString *)executeable {
    return [JSBProjectInfo appInfo][@"CFBundleExecutable"];
}

+ (NSString *)bundleIdentifier {
    return [JSBProjectInfo appInfo][@"CFBundleIdentifier"];
}

+ (float)shortVersion {
    return [[JSBProjectInfo appInfo][@"CFBundleShortVersionString"] floatValue];
}

+ (float)buildVersion {
    return [[JSBProjectInfo appInfo][@"CFBundleVersion"] floatValue];
}


@end
