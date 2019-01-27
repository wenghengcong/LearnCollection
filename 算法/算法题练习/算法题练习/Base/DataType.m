//
//  DataType.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "DataType.h"

@implementation ListNode

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
    ListNode *node = [[ListNode alloc] init];
    node.next = self.next;  //保持链接关系
    node.prev = self.prev;  //保持链接关系
    node.value = [self.value copy];
    return node;
}

@end

@implementation TreeNode

- (instancetype)initWithKey:(nonnull id)key value:(id)value size:(int)size
{
    self = [super init];
    self.key = key;
    self.value = value;
    self.size = size;
    return self;
}

+ (instancetype)nodeWithKey:(nonnull id)key value:(id)value size:(int)size
{
    return [[self alloc] initWithKey:key value:value size:size];
}

- (id)copyWithZone:(NSZone *)zone
{
    // 将属性全部声明为copy
    TreeNode *node = [[TreeNode alloc] init];
    node.left = self.left;  //保持链接关系
    node.right = self.right;  //保持链接关系
    node.key = self.key;
    node.value = [self.value copy];
    node.size = self.size;
    return node;
}

@end
