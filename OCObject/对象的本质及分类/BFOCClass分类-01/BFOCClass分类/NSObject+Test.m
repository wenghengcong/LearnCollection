//
//  NSObject+Test.m
//  BFOCClass分类
//
//  Created by WengHengcong on 2018/11/23.
//  Copyright © 2018 LuCI. All rights reserved.
//

#import "NSObject+Test.h"

@implementation NSObject (Test)

+ (void)test
{
    NSLog(@"+[NSObject test]");
}

- (void)test
{
    NSLog(@"-[NSObject test]");
}

@end
