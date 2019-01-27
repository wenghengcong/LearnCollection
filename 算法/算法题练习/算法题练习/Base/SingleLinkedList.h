//
//  LinkList.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"



/**
 单向链表
 链表计数从1开始，[1....n]
 */
@interface SingleLinkedList<__covariant ObjectType> : NSObject

@property (nonatomic, strong) ListNode *head;
@property (nonatomic, assign) int size;

- (instancetype)initWithArray:(int[])array length:(int)length;
+ (instancetype)linkListWithArray:(int[])array length:(int)length;


#pragma mark - Add
/**
 在头部插入
 */
- (void)addNode:(ListNode *)node;

/**
 在特定位置插入
 */
- (void)insertNode:(ListNode *)node atIndex:(int)index;

#pragma mark - remove

/**
 移除最后一个结点
 */
- (void)removeLastNode;

/**
 移除特定结点（位于排列第一个）
 */
- (void)removeValue:(ObjectType)value;
- (void)removeNode:(ListNode *)node;

/**
 移除特定位置的结点
 */
- (void)removeNodeAtIndex:(int)index;

#pragma mark - get
- (ListNode *)firstNode;
- (ListNode *)lastNode;
- (ListNode *)nodeOfValue:(int)value;
- (ListNode *)nodeAtIndex:(int)index;

#pragma mark - index

/**
 返回节点的Index
 节点定义从1开始计数，计数为 [1...index]
 */
- (int)indexOfNode:(ListNode *)node;

#pragma mark - Cotains
- (BOOL)isEmpty;
- (BOOL)contain:(ListNode *)node;
- (BOOL)containValue:(ObjectType)value;

#pragma mark - other

- (void)print;

@end

