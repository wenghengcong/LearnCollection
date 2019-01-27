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

- (instancetype)initWithArray:(int[])array length:(int)length
{
    self = [self init];
    for (int i = 0; i < length; i++) {
        NSNumber *num = @(array[i]);
        ListNode *node = [ListNode nodeWithValue:num];
        [self push:node];
    }
    return self;
}

+ (instancetype)stackWithArray:(int[])array length:(int)length
{
    return [[self alloc] initWithArray:array length:length];
}

- (void)push:(ListNode *)item
{
    ListNode *oldTop = _top;
    _top = [item copy];
    _top.next = oldTop;
    _size++;
}

- (void)pushValue:(id)value
{
    ListNode *newTop = [[ListNode alloc] init];
    newTop.value = value;
    [self push:newTop];
}

- (nullable ListNode *)pop
{
    NSAssert(![self isEmpty], @"stack is empty");
    ListNode *oldTop = _top;
    _top = _top.next;
    _size--;
    return oldTop;
}

- (nullable id)popValue
{
    ListNode *node = [self pop];
    return node.value;
}

- (nullable ListNode *)peek
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

- (void)print
{
    NSMutableString *output = [NSMutableString string];
    ListNode *current = _top;
    while (current != nil) {
        [output appendString:[NSString stringWithFormat:@"%@->", current.value]];
        current = current.next;
    }
    NSLog(@"Stack: %@", output);
}

@end
