//
//  LinkList.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "LinkList.h"

@implementation LinkList

- (instancetype)init
{
    self = [super init];
    _size = 0;
    return self;
}

- (instancetype)initWithArray:(int[])array length:(int)length
{
    self = [self init];
    for (int i = 0; i < length; i++) {
        NSNumber *num = @(array[i]);
        Node *node = [Node nodeWithValue:num];
        [self addNode:node];
    }
    return self;
}

+ (instancetype)linkListWithArray:(int[])array length:(int)length
{
    return [[self alloc] initWithArray:array length:length];
}

- (void)addNode:(Node *)node
{
    if ([self isEmpty]) {
        _head = node;
    } else {
        Node *oldHead = _head;
        _head = node;
        node.next = oldHead;
    }
    _size++;
}

- (void)insertNode:(Node *)node atIndex:(int)index
{
    
}

// remove
- (void)removeLastNode
{
    NSAssert([self isEmpty], @"List empty");
    Node *p = _head;
    //p --> p.next--> p.next.next
    while (p.next.next != nil) {
        p = p.next;
    }
    p.next = nil;
}

- (void)removeNode:(Node *)node
{
    
}

- (void)removeNodeAtIndex:(int)index
{
    
}

// get
- (Node *)firstNode
{
    return _head;
}

- (Node *)lastNode
{
    return _head;
}
- (Node *)nodeAtIndex:(int)index
{
    return _head;
}

//index
- (int)indexOfNode:(Node *)node
{
    return -1;
}

- (int)indexOfValue:(id)value
{
    return -1;
}

//other

- (BOOL)isEmpty
{
    return _head == nil;
}

- (BOOL)contains:(id)node
{
    return NO;
}

- (void)print
{
    NSMutableString *output = [NSMutableString string];
    Node *current = _head;
    for (int i = 0; i < _size; i++) {
        [output appendString:[NSString stringWithFormat:@"%@->", current.value]];
        current = current.next;
    }
    NSLog(@"linked list: %@", output);
}

@end
