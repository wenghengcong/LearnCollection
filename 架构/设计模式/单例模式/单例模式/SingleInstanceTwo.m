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
 */
- (instancetype)shared
{
    static SingleInstanceTwo *shared = nil;
    @synchronized (self) {
        shared = [[self alloc] init];
    }
    return shared;
}

@end
