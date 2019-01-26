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
 暂时不维护tail结点
 */
@interface SingleLinkedList<__covariant ObjectType> : NSObject

@property (nonatomic, strong) Node *head;
@property (nonatomic, assign) NSInteger size;

- (instancetype)initWithArray:(int[])array length:(int)length;
+ (instancetype)linkListWithArray:(int[])array length:(int)length;


#pragma mark - Add
/**
 在头部插入
 */
- (void)addNode:(Node *)node;

/**
 在特定位置插入
 */
- (void)insertNode:(Node *)node atIndex:(int)index;

#pragma mark - remove

/**
 移除最后一个结点
 */
- (void)removeLastNode;

/**
 移除特定结点（位于排列第一个）
 */
- (void)removeValue:(ObjectType)value;
- (void)removeNode:(Node *)node;

/**
 移除特定位置的结点
 */
- (void)removeNodeAtIndex:(int)index;

#pragma mark - get
- (Node *)firstNode;
- (Node *)lastNode;
- (Node *)nodeAtIndex:(int)index;

#pragma mark - index
- (int)indexOfNode:(Node *)node;

#pragma mark - other

- (BOOL)isEmpty;

- (BOOL)contains:(Node *)value;

- (void)print;

@end

