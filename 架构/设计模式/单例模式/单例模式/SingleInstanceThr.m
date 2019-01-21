//
//  SingleInstanceThr.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleInstanceThr.h"

static SingleInstanceThr *shared;


/**
 饿汉式：
 */
@implementation SingleInstanceThr

+ (void)load
{
    shared = [[self alloc] init];
}

- (instancetype)shared
{
    if (shared == nil) {
        shared = [[SingleInstanceThr alloc] init];
    }
    return shared;
}
@end
