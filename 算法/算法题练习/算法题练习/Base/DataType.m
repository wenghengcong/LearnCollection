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

+ (instancetype)nodeWithValue:(id)value
{
    return [[self alloc] initWithValue:value];
}

- (id)copyWithZone:(NSZone *)zone
{
    // 将属性全部声明为copy
    Node *node = [[Node alloc] init];
    node.next = self.next;  //保持链接关系
    node.prev = self.prev;  //保持链接关系
    node.value = [self.value copy];
    return node;
}

@end
