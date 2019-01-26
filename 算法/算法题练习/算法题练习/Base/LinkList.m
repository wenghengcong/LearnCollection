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
    Node *newNode = [node copy];
    if ([self isEmpty]) {
        _head = newNode;
    } else {
        Node *oldHead = _head;
        _head = newNode;
        newNode.next = oldHead;
    }
    _size++;
}

- (void)insertNode:(Node *)node atIndex:(int)index
{
    
}

// remove
- (void)removeLastNode
{
    NSAssert(![self isEmpty], @"List empty");
    Node *p = _head;
    //p --> p.next--> p.next.next
    while (p.next.next != nil) {
        p = p.next;
    }
    p.next = nil;
    
    _size--;
}

- (void)removeValue:(id)value
{
    // current -> current.next -> current.next.next
    // 移除的是current.next
    Node *current = _head;
    while (current.next != nil) {
        if (current.next.value == value) {
            Node *removeNode = current.next;
            current.next = current.next.next;
            
            // 移除
            removeNode.value = nil;
            removeNode.next = nil;
        }
        current = current.next;
    }
    _size--;
}

- (void)removeNode:(Node *)node
{
    Node *current = _head;
    while (current.next != nil) {
        if (current.next.value == node.value) {
            Node *remove = current.next;
            
            current.next = current.next.next;
            
            remove.value = nil;
            remove.next = nil;
        }
        
        current = current.next;
    }
    _size--;
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
    while (current != nil) {
        [output appendString:[NSString stringWithFormat:@"%@->", current.value]];
        current = current.next;
    }
    NSLog(@"linked list: %@", output);
}

@end
