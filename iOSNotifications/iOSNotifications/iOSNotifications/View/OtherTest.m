//
//  OtherTest.m
//  iOSNotifications
//
//  Created by WengHengcong on 2017/3/20.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "OtherTest.h"
#import "AppDelegate.h"

@implementation OtherTest

#pragma  mark - Test System Version Compare

- (void)testVersion
{
    /*
     iOS 版本号是两位或者三位
     大版本如：8.4，9.2，10.1
     小版本如：8.4.1，9.3.3，10.2.1
     */
    NSString *version = [[UIDevice currentDevice] systemVersion];
    version = @"10.2.1";
    
    NSArray *components = [version componentsSeparatedByString:@"."];
    NSInteger major = 0;
    NSInteger minor = 0;
    NSInteger micro = 0;
    
    if (components.count == 0) {
        major = [version integerValue];
    }else if (components.count == 1){
        major = [version integerValue];
    }if (components.count == 2){
        major = [components[0] integerValue];
        minor = [components[1] integerValue];
    }else if (components.count == 3){
        major = [components[0] integerValue];
        minor = [components[1] integerValue];
        micro = [components[2] integerValue];
    }
    
    NSInteger versionInteget = major * 100 + minor * 10 + micro;
    
    NSLog(@"%ld",(long)versionInteget);
}

- (void)test_systemCompare
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int int_ver = [version intValue];
    float float_ver = [version floatValue];
    double double_ver = [version doubleValue];
    NSLog(@"%@-%d-%f-%f",version,int_ver,float_ver,double_ver);
    
    if (int_ver >= 9) {
        NSLog(@"hah");
    }
    
    if (int_ver >= 9.0) {
        NSLog(@"mmm");
    }
    
    if (int_ver >= 9.3) {
        NSLog(@"sss");
    }
    
    NSInteger ver_int = [[ [UIDevice currentDevice] systemVersion] integerValue];
    if (ver_int >= 10) {
        NSLog(@"gggg");
    }
    
    if ([[ [UIDevice currentDevice] systemVersion] integerValue] >= 10) {
        
    }
    
    double coreVersion = kCFCoreFoundationVersionNumber;
    double nsfoundaVersion = NSFoundationVersionNumber;
    NSLog(@"%f-%f",coreVersion,nsfoundaVersion);
    
    //NSOrderedAscending\NSOrderedDescending
    //前者相对于后者
    //10.0相对于10是低版本，显然不合理，所以该判断也是存在问题的。
    NSInteger compareResult = [@"8.4.1" compare:@"8.2" options:NSNumericSearch];
    NSLog(@"string result %ld",(long)compareResult);
    
    NSDictionary *dic = @{@"name":@"wenghengcong",@"age":@"18"};
    NSString *name = dic[@"name"];
    NSString *country = dic[@"country"];
    NSLog(@"%@%@",name,country);
    
    if ([@"China" isEqualToString:country]) {
        [appDelegate wirteLogWithString:@"print compare result"];
    }
    
    NSString *tstStr = @"8.4.1";
    float flt = [tstStr floatValue];
    if (flt > 8.2) {
        [appDelegate wirteLogWithString:@"haha"];
    }
    SEL selector = NULL;
    if(flt/*some condition */) {
        
    } else if(flt+1/* some ohter condition */) {
        
    } else {
        
    }
    [self performSelector:selector];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

@end
