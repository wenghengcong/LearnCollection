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
    self.count = 0;
    return self;
}

- (void)addNode:(Node *)node
{
    _count++;
    if (_head) {
        node.next = _head;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

- (void)insertNode:(Node *)node atIndex:(int)index
{
    
}

// remove
- (void)removeLastNode
{
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
- (BOOL)contains:(id)node
{
    return NO;
}

- (void)print
{
    
}

@end
