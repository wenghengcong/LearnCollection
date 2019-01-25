//
//  Stack.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (instancetype)init
{
    self = [super init];
    self.top = nil;
    self.size = 0;
    return self;
}

- (void)push:(Node *)item
{
    Node *oldTop = _top;
    _top = item;
    _top.next = oldTop;
    _size++;
}

- (void)pushValue:(id)value
{
    Node *newTop = [[Node alloc] init];
    newTop.value = value;
    [self push:newTop];
}

- (nullable Node *)pop
{
    NSAssert([self isEmpty], @"stack is empty");
    Node *oldTop = _top;
    _top = _top.next;
    _size--;
    return oldTop;
}

- (nullable id)popValue
{
    Node *node = [self pop];
    return node.value;
}

- (nullable Node *)peek
{
    return _top;
}
- (nullable id)peekValue
{
    return _top.value;
}

- (BOOL)isEmpty
{
    return _top == nil;
}


@end
