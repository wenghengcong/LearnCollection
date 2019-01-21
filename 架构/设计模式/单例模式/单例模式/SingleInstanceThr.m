//
//  SingleInstanceThr.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleInstanceThr.h"

static SingleInstanceThr *_shared;

/**
 饿汉式：
 */
@implementation SingleInstanceThr

+ (void)load
{
    _shared = [[self alloc] init];
}

+ (instancetype)sharedThr
{
    if (_shared == nil) {
        _shared = [[self alloc] init];
    }
    return _shared;
}
@end
