//
//  Queue.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "Queue.h"

@implementation Queue

- (instancetype)init
{
    self = [super init];
    _first = nil;
    _last = nil;
    _size = 0;
    return self;
}

- (void)enQueue:(Node *)item
{
    Node *oldLast = _last;
    _last = item;
    _last.next = nil;
    
    if ([self isEmpty]) {
        _first = _last;
    } else {
        oldLast.next = _last;
    }
    _size++;
}

- (void)enQueueWithValue:(id)value
{
    Node *oldLast = _last;

    Node *newLast = [[Node alloc] initWithValue:value];
    _last = newLast;
    _last.next = nil;

    if ([self isEmpty]) {
        _first = _last;
    } else {
        oldLast.next = _last;
    }
    _size++;
}


- (nullable Node *)deQueue
{
    NSAssert([self isEmpty], @"Queue underflow");
    Node *node = _first;
    _first = _first.next;
    _size--;
    if ([self isEmpty]) {
        _last = nil;
    }
    return node;
}

- (nullable id)deQueueValue
{
    return [self deQueue].value;
}

- (nullable Node *)peek
{
    NSAssert([self isEmpty], @"Queue underflow");
    Node *node = _first;
    return node;
}

- (nullable id)peekValue
{
    return [self peek].value;
}


- (BOOL)isEmpty
{
    return _first == nil;
}

@end
