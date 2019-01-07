//
//  BFProxy.m
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFProxy.h"

@implementation BFProxy

+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    BFProxy *proxy = [BFProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
