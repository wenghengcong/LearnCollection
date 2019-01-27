//
//  LinkList.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SingleLinkedList.h"

@implementation SingleLinkedList

#pragma mark - Create
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
        ListNode *node = [ListNode nodeWithValue:num];
        [self addNode:node];
    }
    return self;
}

+ (instancetype)linkListWithArray:(int[])array length:(int)length
{
    return [[self alloc] initWithArray:array length:length];
}

#pragma mark - Add
- (void)addNode:(ListNode *)node
{
    ListNode *newNode = [node copy];
    if ([self isEmpty]) {
        _head = newNode;
    } else {
        ListNode *oldHead = _head;
        _head = newNode;
        newNode.next = oldHead;
    }
    _size++;
}

- (void)insertNode:(ListNode *)node atIndex:(int)index
{
    
}

#pragma mark - Remove
// remove
- (void)removeLastNode
{
    NSAssert(![self isEmpty], @"List empty");
    ListNode *p = _head;
    //p --> p.next--> p.next.next
    while (p.next.next != nil) {
        p = p.next;
    }
    p.next = nil;
    
    _size--;
}

- (void)removeValue:(id)value
{
    if (_head == nil || value == nil) {
        return;
    }
    // current -> current.next -> current.next.next
    // 假如移除的是头结点
    if (_head.value == value) {
        ListNode *current = _head;
        _head = _head.next;
        current = nil;
        _size--;
    } else {
        // 移除的是current.next
        ListNode *current = _head;
        while (current.next != nil) {
            if (current.next.value == value) {
                ListNode *removeNode = current.next;
                current.next = current.next.next;
                removeNode = nil;
                _size--;
                break;
            }
            current = current.next;
        }
    }
}

- (void)removeNode:(ListNode *)node
{
    if (node == nil || _head == nil) {
        return;
    }
    
    ListNode *current = _head;
    // 移除的是头结点
    if (_head == node) {
        _head = _head.next;
        current = nil;
        _size--;
    } else {
        while (current.next != nil) {
            if (current.next == node) {
                ListNode *removeNode = current.next;
                current.next = current.next.next;
                removeNode = nil;
                _size--;
                break;
            }
            current = current.next;
        }
    }
}

- (void)removeNodeAtIndex:(int)index
{
    
}

#pragma mark - Get
// get
- (ListNode *)firstNode
{
    return _head;
}


- (ListNode *)lastNode
{
    ListNode *current = _head;
    while (current.next != nil) {
        current = current.next;
    }
    return current;
}

/**
 未完善
 */
- (ListNode *)nodeOfValue:(int)value
{
    return _head;
}

/**
 未完善
 */
- (ListNode *)nodeAtIndex:(int)index
{
    return _head;
}

#pragma mark - Index
//index
- (int)indexOfNode:(ListNode *)node
{
    return -1;
}

- (int)indexOfValue:(id)value
{
    return -1;
}

#pragma mark - Cotains
- (BOOL)isEmpty
{
    return _head == nil;
}

- (BOOL)contain:(id)node
{
    return NO;
}

- (BOOL)containValue:(id)value
{
    return NO;
}

#pragma mark - Other
- (void)print
{
    NSMutableString *output = [NSMutableString string];
    ListNode *current = _head;
    while (current != nil) {
        [output appendString:[NSString stringWithFormat:@"%@->", current.value]];
        current = current.next;
    }
    NSLog(@"linked list: %@", output);
}

@end
