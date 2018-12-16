//
//  BFBoy.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFBoy.h"
#import <objc/runtime.h>

@implementation BFBoy

- (void)eat
{
    NSLog(@"%s" , __func__);
}

+ (void)eat
{
    NSLog(@"%s" , __func__);
}


@end
