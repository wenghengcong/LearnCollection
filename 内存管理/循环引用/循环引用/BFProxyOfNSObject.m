//
//  BFProxyOfNSObject.m
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFProxyOfNSObject.h"

@implementation BFProxyOfNSObject

+ (instancetype)proxyWithTarget:(id)target
{
    BFProxyOfNSObject *proxy = [[BFProxyOfNSObject alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end
