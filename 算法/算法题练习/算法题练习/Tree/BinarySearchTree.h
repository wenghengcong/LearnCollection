//
//  BinarySearchTree.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/27.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"
// 层序遍历，即广度遍历，需要借助Queue实现
#import "Queue.h"

typedef enum : NSUInteger {
    PrePrintOrder,
    InPrintOrder,
    PostPrintOrder,
    LvevelPrintOrder,
} PrintOrder;

NS_ASSUME_NONNULL_BEGIN
/**
 * 二叉搜索树
 * 1.每个节点的值 都大于其左子树中的任意节点的值，而小于右子树的任意节点的值
 * 2.跟满二叉树或者完全二叉树关系不大
 */
@interface BinarySearchTree<__covariant KeyType, __covariant ObjectType>: NSObject

@property (nonatomic, strong) TreeNode  *root;

@property (nonatomic, assign) int  size;

- (instancetype)initWithArray:(int[])array length:(int)length;

// 获取key对应的值
- (nullable ObjectType)get:(nonnull KeyType)key;
// 插入新节点
- (void)put:(nonnull KeyType)key value:(ObjectType)value;
// 删除节点
- (void)delete:(id)key;

#pragma mark - Order
- (void)preOrder;
- (void)inOrder;
- (void)postOrder;
- (void)levelOrder;

#pragma mark - min/max
- (KeyType)min;
- (KeyType)max;

- (void)deleteMin;
- (void)deleteMax;

#pragma mark - select/rank

/**
 返回 排名为k 的Key
 排名从0开始
 */
- (KeyType)select:(int)k;

/** Key对应的键的排名 */
- (int)rank:(KeyType)key;

#pragma mark - Other
- (void)print:(PrintOrder)order;
@end

NS_ASSUME_NONNULL_END
