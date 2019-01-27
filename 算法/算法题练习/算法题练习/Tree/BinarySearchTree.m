//
//  BinarySearchTree.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/27.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BinarySearchTree.h"

@interface BinarySearchTree()

/**
 存放深度、广度遍历后的序列字符串
 */
@property (nonatomic, copy) NSMutableString     *orderOutput;
@end

@implementation BinarySearchTree

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    _size = 0;
    _orderOutput = [NSMutableString string];
    return self;
}

- (instancetype)initWithArray:(int[])array length:(int)length
{
    self = [self init];
    if (array != nil) {
        for (int i = 0; i < length; i++) {
            NSNumber *num = @(array[i]);
            [self put:num value:num];
        }
    }
    return self;
}

- (nullable id)get:(nonnull id)key
{
    return [self __getNode:_root key:key];
}


- (void)put:(nonnull id)key value:(id)value
{
   _root = [self __putRootNode:_root key:key value:value];
}

#pragma mark - Order
// 前序、中序、后序都是深度遍历
// 前序
- (void)preOrder
{
    _orderOutput = [@"" mutableCopy];
    [self __preOrder:_root];
}
// 中序
- (void)inOrder
{
    _orderOutput = [@"" mutableCopy];
    [self __inOrder:_root];
}
// 后序
- (void)postOrder
{
    // 排序前将其置空
    _orderOutput = [@"" mutableCopy];
    [self __postOrder:_root];
}
// 层序：广度遍历
- (void)levelOrder
{
    
}

#pragma mark - Private

#pragma mark  Order

- (void)__preOrder:(TreeNode *)node
{
    if (node) {
        // 前序输出，这里做想要针对前序做的事情，此处只是打印
        [_orderOutput appendString:[NSString stringWithFormat:@"%@->", node.value]];
        // 遍历左子树
        [self __preOrder:node.left];
        // 遍历右子树
        [self __preOrder:node.right];
    }
}

- (void)__inOrder:(TreeNode *)node
{
    if (node) {
        // 遍历左子树
        [self __inOrder:node.left];
        // 前序输出，这里做想要针对前序做的事情，此处只是打印
        [_orderOutput appendString:[NSString stringWithFormat:@"%@->", node.value]];
        // 遍历右子树
        [self __inOrder:node.right];
    }
}

- (void)__postOrder:(TreeNode *)node
{
    if (node) {
        // 遍历左子树
        [self __postOrder:node.left];
        // 遍历右子树
        [self __postOrder:node.right];
        // 前序输出，这里做想要针对前序做的事情，此处只是打印
        [_orderOutput appendString:[NSString stringWithFormat:@"%@->", node.value]];
    }
}

/**
 在根节点为node的子树中查找并返回key所对应的值
 如果找不到，返回nil
 */
- (nullable id)__getNode:(TreeNode *)node key:(nonnull id)key
{
    NSAssert(key != nil, @"key can't be nil");
    if (node == nil || key == nil) {
        return nil;
    }
    if (key < node.key) {
        return  [self __getNode:node.left key:key];
    } else if (key > node.key) {
        return [self __getNode:node.right key:key];
    } else {
        return node.value;
    }
}


/**
 如果key存在以node为根节点的子树中，则更新它的值
 否则，将以key和value为键值的新节点插入到该子树中
 */
- (TreeNode *)__putRootNode:(TreeNode *)node key:(nonnull id)key value:(id)value
{
    NSAssert(key != nil, @"key can't be nil");
    if (node == nil) {
        _size++;    // 计算当前二叉搜索树的size
        return [TreeNode nodeWithKey:key value:value size:1];
    }
    int cmp = [key compare:node.key];
    if (cmp < 0) {
        node.left = [self __putRootNode:node.left key:key value:value];
    } else if (cmp > 0) {
        node.right = [self __putRootNode:node.right key:key value:value];
    } else {
        node.value = value;
    }
    node.size = node.left.size + node.right.size + 1;   //计算子树的size
    return node;
}

- (void)print
{
    NSLog(@"%@", _orderOutput);
}

@end
