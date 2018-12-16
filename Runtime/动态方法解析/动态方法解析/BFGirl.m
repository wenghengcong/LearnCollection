//
//  BFGirl.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFGirl.h"
#import <objc/runtime.h>

@implementation BFGirl

/*------------------实例方法动态解析：方式一------------------*/
void notFound_learn(id self, SEL _cmd)
{
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
    NSLog(@"current in method %s", __func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(learn)) {
        // 第一个参数是object_getClass(self)
        class_addMethod(object_getClass(self), sel, (IMP)notFound_learn, "v16@0:8");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

@end
