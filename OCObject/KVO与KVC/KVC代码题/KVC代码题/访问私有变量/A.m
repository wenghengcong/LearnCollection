//
//  A.m
//  KVC代码题
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "A.h"

@interface A()
{
    NSString *_a;
}

@end

@implementation A

- (instancetype)init
{
    if (self = [super init]) {
        _a = @"hello";
    }
    return self;
}
@end
