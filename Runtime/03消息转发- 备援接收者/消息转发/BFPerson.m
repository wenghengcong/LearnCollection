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

/**
 备援接收者
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(eat)) {
         // objc_msgSend([[BFBoy alloc] init], aSelector)
        return [[BFBoy alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
