//
//  SynchronizedDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "SynchronizedDemo.h"
#include <stdatomic.h>

@implementation SynchronizedDemo

- (void)usage
{
//    @synchronized (obj) {
//        //任务
//    }
}

- (void)__drawMoney
{
    @synchronized([self class]) {
        [super __drawMoney];
    }
}

- (void)__saveMoney
{
    // 断点调试，汇编代码可以查看到入口
    // 可以在CF中查看实现源码
    @synchronized([self class]) { // objc_sync_enter
        [super __saveMoney];
    } // objc_sync_exit
}

- (void)__saleTicket
{
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized(lock) {
        [super __saleTicket];
    }
}

- (void)otherTest
{
    @synchronized([self class]) {
        NSLog(@"123");
        [self otherTest];
    }
}
@end
