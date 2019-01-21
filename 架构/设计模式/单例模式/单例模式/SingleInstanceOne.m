//
//  SingleInstanceOne.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleInstanceOne.h"

@implementation SingleInstanceOne

/**
 懒汉式：GCD实现
 */
- (instancetype)shared
{
    static SingleInstanceOne *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SingleInstanceOne alloc] init];
    });
    return shared;
}

@end
