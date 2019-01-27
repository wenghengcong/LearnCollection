//
//  DataType.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 链接结点
 */
@interface ListNode<__covariant ObjectType> : NSObject <NSCopying>
// 下一个结点
@property (nonatomic, strong) ListNode<ObjectType> *next;
// 上一个结点
@property (nonatomic, strong) ListNode<ObjectType> *prev;
// 数据
@property (nonatomic, copy) ObjectType value;

- (instancetype)initWithValue:(id)value;
+ (instancetype)nodeWithValue:(id)value;

@end

@interface TreeNode<__covariant KeyType, __covariant ObjectType> : NSObject <NSCopying>
/** 左子节点 */
@property (nonatomic, strong) TreeNode<KeyType, ObjectType>  *left;

/** 右子节点 */
@property (nonatomic, strong) TreeNode<KeyType, ObjectType>  *right;

/** 键 */
@property (nonatomic, copy) KeyType     key;

/** 值 */
@property (nonatomic, copy) ObjectType  value;

/**
 以该节点为根的紫苏中的节点总数
 */
@property (nonatomic, assign) int size;

- (instancetype)initWithKey:(nonnull KeyType)key value:(ObjectType)value size:(int)size;
+ (instancetype)nodeWithKey:(nonnull KeyType)key value:(ObjectType)value size:(int)size;
@end
