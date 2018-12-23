//
//  ViewController.m
//  NSTimer失效
//
//  Created by WengHengcong on 2018/12/21.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //在滑动时，定时器会停止
    //停止滑动后，恢复定时
    
    // 方式1：创建timer，手动添加到default mode，滑动时定时器停止
//    static int count = 0;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%d", ++count);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode: NSDefaultRunLoopMode];
    
    
    // 方式2：创建timer默认添加到default mode，滑动时定时器停止
//    static int count = 0;
    // Creates a timer and schedules it on the current run loop in the default mode.
//    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%d", ++count);
//    }];
    

    // 解决一：手动添加到两种模式下，即可避免停止
//    static int count = 0;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%d", ++count);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    // 解决一：添加到_commonModes，RunLoop会自动将timer添加到两种mode下，即可避免停止
    // NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
    // NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
    // timer能在_commonModes数组中存放的模式下工作
    static int count = 0;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%d", ++count);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

@end
