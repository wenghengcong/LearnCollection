//
//  BFPerson.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"
#import "BFBoy.h"
#import <objc/runtime.h>

@implementation BFPerson

+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(eat)) {
//        return [BFBoy class];
        //假如转发给BFBoy实例对象，就会调用对应的实例方法-[BFBoy eat]
        return [[BFBoy alloc] init];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(eat)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //可以不用再用临时变量，因为[BFBoy class]不会释放，存在全局区
    anInvocation.target = [BFBoy class];
    [anInvocation invoke];
    
    //同样可以转发给BFBoy实例对象
//    BFBoy *boy = [[BFBoy alloc] init];
//    anInvocation.target = boy;
//    [anInvocation invoke];
}

@end
