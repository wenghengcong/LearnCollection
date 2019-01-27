//
//  BinarySearchTree.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/27.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 二叉搜索树
 * 1.每个节点的值 都大于其左子树中的任意节点的值，而小于右子树的任意节点的值
 * 2.跟满二叉树或者完全二叉树关系不大
 */
@interface BinarySearchTree<__covariant KeyType, __covariant ObjectType> : NSObject

@property (nonatomic, strong) TreeNode  *root;

@property (nonatomic, assign) int  size;

- (instancetype)initWithArray:(int[])array length:(int)length;

- (nullable ObjectType)get:(nonnull KeyType)key;

- (void)put:(nonnull KeyType)key value:(ObjectType)value;

#pragma mark - Order
- (void)preOrder;
- (void)inOrder;
- (void)postOrder;


- (void)print;
@end

NS_ASSUME_NONNULL_END
