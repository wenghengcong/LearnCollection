//
//  DataType.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "DataType.h"

@implementation Node

- (instancetype)initWithValue:(id)value
{
    if (self = [self init]) {
        self.value = value;
        self.next = nil;
        self.prev = nil;
    }
    return self;
}

@end
