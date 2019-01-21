//
//  SingleInstanceTwo.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleInstanceTwo.h"

@implementation SingleInstanceTwo
/**
 懒汉式：互斥锁实现
 互斥锁@synchronized，极大的影响性能
 */
+ (instancetype)sharedTwo
{
    static SingleInstanceTwo *_shared = nil;
    @synchronized (self) {
        if (_shared == nil) {
            _shared = [[self alloc] init];
        }
    }
    return _shared;
}

@end
