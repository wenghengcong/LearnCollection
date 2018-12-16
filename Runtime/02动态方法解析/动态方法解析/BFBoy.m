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

/*------------------实例方法动态解析：方式一------------------*/
void notFound_eat(id self, SEL _cmd)
{
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
    NSLog(@"current in method %s", __func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(eat)) {
        // 动态添加eat方法的实现
        class_addMethod(self, sel, (IMP)notFound_eat, "v16@0:8");
        // 返回YES代表有动态添加方法
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//
//}

/*------------------实例方法动态解析：方式二------------------*/
//-(void)notFound_eat
//{
//    NSLog(@"current in method %s", __func__);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(eat)) {
//        // 获取其他方法
//        Method method = class_getInstanceMethod(self, @selector(notFound_eat));
//
//        // 动态添加notFoundInstaceMethod_eat方法的实现
//        class_addMethod(self, sel,
//                        method_getImplementation(method),
//                        method_getTypeEncoding(method));
//
//        // 返回YES代表有动态添加方法
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

/*------------------实例方法动态解析：方式三，非常规，最好不要使用，此处仅做演示------------------*/
// typedef struct objc_method *Method;
// struct objc_method == struct method_t
//        struct method_t *otherMethod = (struct method_t *)class_getInstanceMethod(self, @selector(other));

//struct method_t {
//    SEL sel;
//    char *types;
//    IMP imp;
//};
//
//-(void)notFound_eat
//{
//    NSLog(@"current in method %s", __func__);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(eat)) {
//        // 获取其他方法
//        struct method_t *method = (struct method_t *)class_getInstanceMethod(self, @selector(notFound_eat));
//
//        // 动态添加test方法的实现
//        class_addMethod(self, sel, method->imp, method->types);
//
//        // 返回YES代表有动态添加方法
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

@end
