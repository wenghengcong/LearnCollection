//
//  ViewController.m
//  ARC
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)testCFObject
{
    //1.__bridge_retained
    //等价于CFBridgingRetain函数，将一个OC指针转换为一个CF指针，同时移交所有权，需要手动调用CFRelease来释放CF对象
    NSString *s1 = [[NSString alloc] initWithFormat:@"HelloHelloHelloHelloHello"];
    CFStringRef s2 = (__bridge_retained CFStringRef)s1;
    // or CFStringRef s2 = (CFStringRef)CFBridgingRetain(s1)
    // do something with s2
    //这一行必须要，不然会内存泄漏
    CFRelease(s2);
    
    //2.__bridge_transfer
    //等价于CFBridgingRelease，将一个CF指针转换为OC指针，同时移交所有权，ARC负责管理这个OC指针的生命周期。
    CFStringRef s3 = CFStringCreateWithCString(kCFAllocatorDefault, "abc", kCFStringEncodingEUC_CN);
    NSString *s4 = (__bridge_transfer NSString *)s3;
    NSLog(@"%ld",(long)s4.length);
    CFRelease(s3);
    
    //3.__bridge
    //进行OC指针和CF指针之间的转换，不涉及对象所有权转换，原CF对象需手动调用CFRelease释放对象。
    NSString * s5 = [NSString stringWithFormat:@"%ld",random()];
    CFStringRef s6 = (__bridge CFStringRef)s5;
    NSLog(@"%ld",(long)CFStringGetLength(s6));
    
    CFStringRef s7 = CFStringCreateWithFormat (NULL, NULL, CFSTR("%d"), rand());
    NSString *s8 = (__bridge NSString *)s7;
    NSLog(@"%ld",(long)s8.length);
    //这一行必须要，不然会内存泄漏
    CFRelease(s7);
}

@end
