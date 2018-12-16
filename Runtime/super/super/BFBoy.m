//
//  BFBoy.m
//  super
//
//  Created by WengHengcong on 2018/12/16.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFBoy.h"


/*
 [super message]的底层实现
 1.消息接收者仍然是子类对象
 2.从父类开始查找方法的实现
 */
struct objc_super {
    __unsafe_unretained _Nonnull id receiver; // 消息接收者
    __unsafe_unretained _Nonnull Class super_class; // 消息接收者的父类
};

@implementation BFBoy


- (void)eat
{
    // super调用的receiver仍然是BFPerson对象
    //    struct objc_super arg = {self, [BFPerson class]};
    //    objc_msgSendSuper(arg, @selector(eat));
    [super eat];
}

- (instancetype)init
{
    if (self = [super init]) {
        // objc_msgSend(self, @selector(class));
        NSLog(@"[self class] = %@", [self class]);                // BFBoy
        NSLog(@"[self superclass] = %@", [self superclass]);      // BFPerson
        
        NSLog(@"--------------------------------");
        
        // objc_msgSendSuper({self, [BFPerson class]}, @selector(class));
        NSLog(@"[super class] = %@", [super class]);              // BFBoy
        NSLog(@"[super superclass] = %@", [super superclass]);    // BFPerson
    }
    return self;
}

//@implementation NSObject
//
//- (Class)class
//{
//    return object_getClass(self);
//}
//
//- (Class)superclass
//{
//    return class_getSuperclass(object_getClass(self));
//}
//
//@end


@end
