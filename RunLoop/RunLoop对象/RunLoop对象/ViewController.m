//
//  ViewController.m
//  RunLoop对象
//
//  Created by WengHengcong on 2018/12/20.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self RunLoopMode];
}

- (void)getRunLoop
{
    //Foundation
    NSRunLoop *runLoop1 = [NSRunLoop currentRunLoop];
    NSRunLoop *mainRunLoop1 = [NSRunLoop mainRunLoop];
    
    // Core Foundation
    CFRunLoopRef runLoop2 = CFRunLoopGetCurrent();
    CFRunLoopRef mainRunLoop2 = CFRunLoopGetMain();
    
    //两个地址不一样，NSRunLoop是对CFRunLoopRef的包装对象
    NSLog(@"%p %p", [NSRunLoop currentRunLoop], [NSRunLoop mainRunLoop]);
    NSLog(@"%p %p", CFRunLoopGetCurrent(), CFRunLoopGetMain());
}

- (void)RunLoopMode
{
    // 打印后可以观察到下面的模式：
    //    kCFRunLoopDefaultMode;
    //    NSDefaultRunLoopMode;
    NSLog(@"%@", [NSRunLoop mainRunLoop]);
}

- (void)observerRunLoop
{
    // 创建Observer
    //    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunLoopActicities, NULL);
    //    // 添加Observer到RunLoop中
    //    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    //    // 释放
    //    CFRelease(observer);
    
    // 创建Observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopEntry - %@", mode);
                CFRelease(mode);
                break;
            }
                
            case kCFRunLoopExit: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopExit - %@", mode);
                CFRelease(mode);
                break;
            }
            default:
                break;
        }
    });
    // 添加Observer到RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 释放
    CFRelease(observer);
}

@end
