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

- (instancetype)initWithArray:(int[])array length:(int)length
{
    self = [self init];
    for (int i = 0; i < length; i++) {
        NSNumber *num = @(array[i]);
        ListNode *node = [ListNode nodeWithValue:num];
        [self enQueue:node];
    }
    return self;
}

+ (instancetype)queueWithArray:(int[])array length:(int)length
{
    return [[self alloc] initWithArray:array length:length];
}

- (void)enQueue:(ListNode *)item
{
    ListNode *newLast = [item copy];
    ListNode *oldLast = _last;
    _last = newLast;
    _last.next = nil;
    
    if ([self isEmpty]) {
        _first = _last;
    } else {
        oldLast.next = newLast;
    }
    _size++;
}

- (void)enQueueWithValue:(id)value
{
    ListNode *oldLast = _last;

    ListNode *newLast = [[ListNode alloc] initWithValue:value];
    _last = newLast;
    _last.next = nil;

    if ([self isEmpty]) {
        _first = _last;
    } else {
        oldLast.next = _last;
    }
    _size++;
}


- (nullable ListNode *)deQueue
{
    NSAssert(![self isEmpty], @"Queue underflow");
    ListNode *node = _first;
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

- (nullable ListNode *)peek
{
    NSAssert(![self isEmpty], @"Queue underflow");
    ListNode *node = _first;
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

- (void)print
{
    NSMutableString *output = [NSMutableString string];
    ListNode *current = _first;
    while (current != nil) {
        [output appendString:[NSString stringWithFormat:@"%@->", current.value]];
        current = current.next;
    }
    NSLog(@"Queue: %@",output);
}

@end
