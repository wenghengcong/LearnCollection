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

- (void)eat:(NSString *)food
{
    NSLog(@"%s" , __func__);
}

/*------------------实例方法动态解析------------------*/
//void notFound_eat(id self, SEL _cmd)
//{
//    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"%s", __func__);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(eat)) {
//        // 动态添加eat方法的实现
//        class_addMethod(self, sel, (IMP)notFound_eat, "v16@0:8");
//        // 返回YES代表有动态添加方法
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

@end
