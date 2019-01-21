//
//  SingleInstanceOne.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleInstanceOne.h"

static SingleInstanceOne *_shared = nil;
@implementation SingleInstanceOne

/**
 懒汉式：GCD实现
 */
+ (instancetype)sharedOne
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_shared == nil) {
        _shared = [self sharedOne];
    }
    return _shared;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [SingleInstanceOne sharedOne];
}

@end
