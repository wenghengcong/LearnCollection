//
//  UIDevice+JS.m
//  timeboy
//
//  Created by wenghengcong on 15/6/6.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIDevice+JS.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>


static float _pointsPerCentimeter;
static float _pointsPerInch;

@implementation UIDevice(JS)


+ (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

+ (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Atomicbird
+ (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

+ (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!
+ (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
+ (NSUInteger) platformType
{
    NSString *platform = [self platform];
    // if ([platform isEqualToString:@"XX"])			return UIDeviceUnknown;
    
    if ([platform isEqualToString:@"iFPGA"])		return UIDeviceIFPGA;
    
    if ([platform isEqualToString:@"iPhone1,1"])	return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])	return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])	return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])			return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])			return UIDevice4siPhone;
    
    if ([platform hasPrefix:@"iPhone5,2"]
        ||[platform hasPrefix:@"iPhone5,1"])			return UIDevice5iPhone;
    
    if ([platform hasPrefix:@"iPhone5,4"]
        ||[platform hasPrefix:@"iPhone5,3"])			return UIDevice5cPhone;
    
    if ([platform hasPrefix:@"iPhone6,1"]
        ||[platform hasPrefix:@"iPhone6,2"])			return UIDevice5siPhone;
    
    if ([platform hasPrefix:@"iPhone7,1"])			return UIDevice6PiPhone;
    if ([platform hasPrefix:@"iPhone7,2"])			return UIDevice6iPhone;
    
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
    if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
    if ([platform isEqualToString:@"iPod3,1"])   return UIDevice3GiPod;
    if ([platform isEqualToString:@"iPod4,1"])   return UIDevice4GiPod;
    if ([platform isEqualToString:@"iPod5,1"])   return UIDevice5GiPod;
    
    if ([platform isEqualToString:@"iPad1,1"])   return UIDevice1GiPad;
    
    if ([platform isEqualToString:@"iPad2,1"]
        ||[platform isEqualToString:@"iPad2,2"]
        ||[platform isEqualToString:@"iPad2,3"]
        ||[platform isEqualToString:@"iPad2,4"])   return UIDevice2GiPad;
    
    if ([platform isEqualToString:@"iPad3,1"]
        ||[platform isEqualToString:@"iPad3,2"]
        ||[platform isEqualToString:@"iPad3,3"])   return UIDevice3GiPad;
    
    if ([platform isEqualToString:@"iPad3,4"]
        ||[platform isEqualToString:@"iPad3,5"]
        ||[platform isEqualToString:@"iPad3,6"])   return UIDevice4GiPad;
    
    if ([platform isEqualToString:@"iPad4,1"]
        ||[platform isEqualToString:@"iPad4,2"]
        ||[platform isEqualToString:@"iPad4,3"])   return UIDeviceAirGiPad;
    
    if ([platform isEqualToString:@"iPad5,3"]
        || [platform isEqualToString:@"iPad5,4"])return UIDeviceAir2GiPad;
    
    
    if ([platform isEqualToString:@"iPad2,5"]
        ||[platform isEqualToString:@"iPad2,6"]
        ||[platform isEqualToString:@"iPad2,7"])   return UIDeviceiPadMini;
    
    if ([platform isEqualToString:@"iPad4,4"]
        ||[platform isEqualToString:@"iPad4,5"]
        ||[platform isEqualToString:@"iPad4,6"])   return UIDeviceiPadMini2;
    
    if ([platform isEqualToString:@"iPad4,7"]
        ||[platform isEqualToString:@"iPad4,8"]
        ||[platform isEqualToString:@"iPad4,9"])   return UIDeviceiPadMini3;
    
    if ([platform isEqualToString:@"AppleTV2,1"])	return UIDeviceAppleTV2;
    if ([platform isEqualToString:@"AppleTV3,1"])	return UIDeviceAppleTV3;
    if ([platform isEqualToString:@"AppleTV3,2"])	return UIDeviceAppleTV3;
    /*
     MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
     */
    
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceUnknowniPad;
    
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) // thanks Jordan Breeding
    {
        if ([[UIScreen mainScreen] bounds].size.width < 768)
            return UIDeviceiPhoneSimulatoriPhone;
        else
            return UIDeviceiPhoneSimulatoriPad;
        
        return UIDeviceiPhoneSimulator;
    }
    return UIDeviceUnknown;
}

+ (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone:	return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone:	return IPHONE_4_NAMESTRING;
        case UIDevice4siPhone:	return IPHONE_4s_NAMESTRING;
        case UIDevice5iPhone:	return IPHONE_5_NAMESTRING;
        case UIDevice5cPhone:	return IPHONE_5c_NAMESTRING;
        case UIDevice5siPhone:	return IPHONE_5s_NAMESTRING;
        case UIDevice6iPhone:	return IPHONE_6_NAMESTRING;
        case UIDevice6PiPhone:	return IPHONE_6_P_NAMESTRING;
            
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDevice5GiPod: return IPOD_5G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDevice4GiPad : return IPAD_4G_NAMESTRING;
        case UIDeviceAirGiPad : return IPAD_Air_NAMESTRING;
        case UIDeviceAir2GiPad : return IPAD_Air2_NAMESTRING;
            
        case UIDeviceiPadMini : return IPAD_Mini_NAMESTRING;
        case UIDeviceiPadMini2 : return IPAD_Mini2_NAMESTRING;
        case UIDeviceiPadMini3 : return IPAD_Mini3_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
            
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IPOD_FAMILY_UNKNOWN_DEVICE;
    }
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString *) macaddress
{
    int					mib[6];
    size_t				len;
    char				*buf;
    unsigned char		*ptr;
    struct if_msghdr	*ifm;
    struct sockaddr_dl	*sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *) platformCode
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return @"M68";
        case UIDevice3GiPhone: return @"N82";
        case UIDevice3GSiPhone:	return @"N88";
        case UIDevice4iPhone: return @"N89";
        case UIDevice5iPhone: return IPHONE_UNKNOWN_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return @"N45";
        case UIDevice2GiPod: return @"N72";
        case UIDevice3GiPod: return @"N18";
        case UIDevice4GiPod: return @"N80";
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad: return @"K48";
        case UIDevice2GiPad: return IPAD_UNKNOWN_NAMESTRING;
        case UIDeviceUnknowniPad: return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2:	return @"K66";
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
            
        default: return IPOD_FAMILY_UNKNOWN_DEVICE;
    }
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark -
#pragma mark Public Methods

+ (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [UIDevice macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [UIDevice md5Sum:stringToHash];
    
    return uniqueIdentifier;
}

+ (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [UIDevice  macaddress];
    NSString *uniqueIdentifier = [UIDevice md5Sum:macaddress];
    
    return uniqueIdentifier;
}

+ (BOOL)isMCOK{
    __block BOOL ok = YES;
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        if ([self isIOS7]) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    ok = YES;
                    NSLog(@"允许使用麦克风！");
                }
                else {
                    NSLog(@"不允许使用麦克风！");
                    ok = NO;
                }
            }];
        }
        
    }
    return ok;
}
+ (BOOL)isIOS7
{
    NSString *str =[[UIDevice currentDevice] systemVersion];
    NSArray *array = [str componentsSeparatedByString:@"."];
    if ([array[0] intValue] >= 7) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isIOS8
{
    NSString *str =[[UIDevice currentDevice] systemVersion];
    NSArray *array = [str componentsSeparatedByString:@"."];
    if ([array[0] intValue] >= 8) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isiPhone6
{
    return [self platformType] == UIDevice6iPhone;
}
+ (BOOL)isiPhone6P
{
    return [self platformType] == UIDevice6PiPhone;
}
+ (float)mathiPhoneType:(float)f
{
    if ([self isiPhone6]) {
        return f;
    }else if ([self isiPhone6P]){
        return f*1.104;
    }else {
        return f*0.853333333;
    }
}
+ (BOOL)isIphone5
{
    if (([self platformType] == UIDevice5iPhone) ||([self platformType] == UIDevice5cPhone) || ([self platformType] == UIDevice5siPhone)) {
        return YES;
    }
    return NO;
    
}
+ (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

#pragma mark- screen resolution

+(void)initializeScreenParameter {
    struct utsname sysinfo;
    
    if (uname(&sysinfo) == 0) {
        NSString *identifier = [NSString stringWithUTF8String:sysinfo.machine];
        
        // group devices with same points-density
        NSArray *iDevices = @[@{@"identifiers": @[@"iPad1,1",                                      // iPad
                                                  @"iPad2,1", @"iPad2,2", @"iPad2,3", @"iPad2,4",  // iPad 2
                                                  @"iPad3,1", @"iPad3,2", @"iPad3,3",              // iPad 3
                                                  @"iPad3,4", @"iPad3,5", @"iPad3,6",              // iPad 4
                                                  @"iPad4,1", @"iPad4,2", @"iPad4,3",              // iPad Air
                                                  @"iPad5,3", @"iPad5,4"],                         // iPad Air 2
                                @"pointsPerCentimeter":  @52.0f,
                                @"pointsPerInch":       @132.0f},
                              
                              @{@"identifiers": @[@"iPod5,1",                                      // iPod Touch 5th generation
                                                  @"iPhone1,1",                                    // iPhone 2G
                                                  @"iPhone1,2",                                    // iPhone 3G
                                                  @"iPhone2,1",                                    // iPhone 3GS
                                                  @"iPhone3,1", @"iPhone3,2", @"iPhone3,3",        // iPhone 4
                                                  @"iPhone4,1",                                    // iPhone 4S
                                                  @"iPhone5,1", @"iPhone5,2",                      // iPhone 5
                                                  @"iPhone5,3", @"iPhone5,4",                      // iPhone 5C
                                                  @"iPhone6,1", @"iPhone6,2",                      // iPhone 5S
                                                  @"iPad2,5", @"iPad2,6", @"iPad2,7",              // iPad Mini
                                                  @"i386", @"x86_64"],                             // iOS simulator (assuming iPad Mini simulator)
                                @"pointsPerCentimeter":  @64.0f,
                                @"pointsPerInch":       @163.0f},
                              
                              
                              @{@"identifiers": @[@"iPhone7,1"],                                   // iPhone 6 Plus
                                @"pointsPerCentimeter":  @158.0f,
                                @"pointsPerInch":       @401.0f},
                              
                              @{@"identifiers": @[@"iPhone7,2",                                    // iPhone 6
                                                  @"iPad4,4", @"iPad4,5",  @"iPad4,6",             // iPad Mini Retina (2)
                                                  @"iPad4,7", @"iPad4,8",  @"iPad4,9"],            // iPad Mini 3
                                @"pointsPerCentimeter":  @128.0f,
                                @"pointsPerInch":       @326.0f}
                              ];
        
        for (id deviceClass in iDevices)
            for (NSString *deviceId in [deviceClass objectForKey:@"identifiers"])
                if ([identifier isEqualToString:deviceId]) {
                    _pointsPerCentimeter = [[deviceClass objectForKey:@"pointsPerCentimeter"] floatValue];
                    _pointsPerInch       = [[deviceClass objectForKey:@"pointsPerInch"] floatValue];
                    break;
                }
    }
    
    NSAssert(_pointsPerCentimeter > 0.0f || _pointsPerInch > 0.0f, @"Unknown device: %s", sysinfo.machine);
}

+ (float)pointsPerCentimeter
{
    [UIDevice initializeScreenParameter];
    return _pointsPerCentimeter;
}
+ (float)pixelsPerCentimeter
{
    [UIDevice initializeScreenParameter];
    return _pointsPerCentimeter * [[UIScreen mainScreen] scale];
} // map from POINTS to PIXELS

+ (float)pointsPerInch
{
    [UIDevice initializeScreenParameter];
    return _pointsPerInch;
}
+ (float)pixelsPerInch
{
    [UIDevice initializeScreenParameter];
    return _pointsPerInch * [[UIScreen mainScreen] scale];
} // map from POINTS to PIXELS


+ (NSString *)md5Sum:(NSString *)str
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([str UTF8String], (uint32_t)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for (i=0;i<CC_MD5_DIGEST_LENGTH;i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

@end
