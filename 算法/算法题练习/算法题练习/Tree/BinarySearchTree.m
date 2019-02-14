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

#pragma mark Create

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

#pragma mark get/put
/**
 在二分搜索树中查找Key所对应的值，如果不存在，返回nil
 */
- (nullable id)get:(nonnull id)key
{
    return [self __getNode:_root key:key];
}

/**
 插入一个新的(key,value)数据对
 */
- (void)put:(nonnull id)key value:(id)value
{
   _root = [self __putRootNode:_root key:key value:value];
}

#pragma mark Order
// 前序、中序、后序都是深度遍历
// 前序
- (void)preOrder
{
    [self __preOrder:_root];
}
// 中序
- (void)inOrder
{
    [self __inOrder:_root];
}
// 后序
- (void)postOrder
{
    [self __postOrder:_root];
}
// 层序：广度遍历
- (void)levelOrder
{
    _orderOutput = [@"" mutableCopy];
    Queue<TreeNode *> *queue = [[Queue alloc] init];
    [queue enQueueWithValue:_root];
    while (!queue.isEmpty) {
        TreeNode *node = [queue deQueueValue];
        [_orderOutput appendString:[NSString stringWithFormat:@"%@[%d]->", node.value, node.size]];
        if (node.left) {
            [queue enQueueWithValue:node.left];
        }
        if (node.right) {
            [queue enQueueWithValue:node.right];
        }
    }
}

#pragma mark min/max
/**
 返回最小键的key
 */
- (id)min
{
    return [self __min:_root].key;
}

- (id)max
{
    return [self __max:_root].key;
}

- (void)deleteMin
{
    if (_root) {
        _root = [self __deleteMin:_root];
    }
}

- (void)deleteMax
{
    if (_root) {
        _root = [self __deleteMax:_root];
    }
}

- (void)delete:(id)key
{
    _root = [self __delete:key node:_root];
}


#pragma mark select/rank
/**
 返回 排名为k 的Key
 定义为：有k个键 小于它
 */
- (id)select:(int)k
{
    return [self __select:k node:_root].key;
}

/** Key对应的键的排名 */
- (int)rank:(id)key
{
    return [self __rank:key node:_root];
}


/** 私有方法 */
#pragma mark - Private

#pragma mark min/max

- (TreeNode *)__min:(TreeNode *)node
{
    // 如果没有左子树，就找到了最小key，返回该node
    if (node.left == nil) return node;
    // 否则，继续向左子树查找
    return [self __min:node.left];
}

- (TreeNode *)__max:(TreeNode *)node
{
    if(node.right == nil) return node;
    return [self __max:node.right];
}

- (TreeNode *)__deleteMin:(TreeNode *)node
{
    // 查找最小左子树，即最小节点的位置
    if(node.left == nil) {
        // 找到最小节点的位置node
        // 维护整棵树的节点数目
        _size--;
        // 找到后，删除该节点，删除该节点，就是相当于将node的右节点返回，赋给上一个节点，即使右节点为空，也符合
        return node.right;
    }
    // 否则，继续寻找左子树
    node.left = [self __deleteMin:node.left];
    // 维护node为根节点的子树的节点数目
    node.size = node.left.size + node.right.size + 1;
    return node;
}

- (TreeNode *)__deleteMax:(TreeNode *)node
{
    if (node.right == nil) {
        // 维护整棵树的节点数目
        _size--;
        return node.left;
    }
    node.right = [self __deleteMax:node.right];
    // 维护node为根节点的子树的节点数目
    node.size = node.left.size + node.right.size + 1;
    return node;
}

- (TreeNode *)__delete:(id)key node:(TreeNode *)node
{
    if (node == nil) {
        return nil;
    }
    
    int cmp = [key compare:node.key];
    // 遍历子树，寻找需要删除的节点
    if (cmp < 0) {
        node.left = [self __delete:key node:node.left];
    } else if (cmp > 0) {
        node.right = [self __delete:key node:node.right];
    } else {
        // 找到要删除的节点，分为三种情况
        
        // 1. 无左子树，直接将右子树返回
        if (node.left == nil) {
            return node.right;
        }
        // 2.无右子树，直接将左子树返回
        if (node.right == nil) {
            return node.left;
        }
        
        // 3.既有左子树，又有右子树
        /*
            删除后，需要继续满足二叉搜索树的性质，即  左子树<根<右子树，将哪个节点提上来能继续满足呢？
            3.1 将左子树中的最大节点提上来
            3.2 将右子树中的最小节点提上来，此处用这种方式
            最大、最小节点根据上面的deleteMin，deleteMax就可以得到
         */
        TreeNode *upNode = [self __min:node.right]; //获得最小节点
        upNode.left = node.left;           // 上提的右子树最小节点的左节点，是将要删除的节点的左节点，即左节点部分不变动
        upNode.right = [self __deleteMax:node.right];     // 上提的右子树的最小节点的右节点，即deleteMax中返回的节点
        node = upNode;      // 赋值返回
        
        _size--;
    }
    node.size = node.left.size + node.right.size + 1;
    return node;
}

#pragma mark Order

- (void)__preOrder:(TreeNode *)node
{
    // 迭代实现
    if (node) {
        // 前序输出，这里做想要针对前序做的事情，此处只是打印
        [_orderOutput appendString:[NSString stringWithFormat:@"%@[%d]->", node.value, node.size]];
        // 遍历左子树
        [self __preOrder:node.left];
        // 遍历右子树
        [self __preOrder:node.right];
    }
    
    // TODO: 循环实现
   
}

- (void)__inOrder:(TreeNode *)node
{
    if (node) {
        // 遍历左子树
        [self __inOrder:node.left];
        // 前序输出，这里做想要针对前序做的事情，此处只是打印
        [_orderOutput appendString:[NSString stringWithFormat:@"%@[%d]->", node.value, node.size]];
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
        [_orderOutput appendString:[NSString stringWithFormat:@"%@[%d]->", node.value, node.size]];
    }
}

#pragma mark get/put

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

// 选择：假设我们想找到排名为k的键（即树中正好有k个小于它的键）。
// 如果左子树中的结点数t大于k，那么我们就继续（递归地）在左子树中查找排名为k的键；
// 如果t等于k，我们就返回根结点中的键；如果t小于k，我们就（递归地）在右子树中查找排名为（k-t-1）的键
- (TreeNode *)__select:(int)k node:(TreeNode *)node
{
    if (node == nil) {
        return nil;
    }
    int leftSize = node.left.size;
    if (k < leftSize) {
        // k 比当前左子树的小，说明在左子树中，并且仍然是排名为k
        return [self __select:k node:node.left];
    } else if(k > leftSize) {
        // k 比当前的左子树大，即在当前右子树中，那么在右子树的排名为：k-leftSize-1(包含leftSize，以及根节点)
        return [self __select:k-leftSize-1 node:node.right];
    } else {
        return node;
    }
}

// 排名：rank()是select()的逆方法，它会返回给定键的排名。
// 如果给定的键和根结点的键相等，我们返回左子树中的结点总数t；
// 如果给定的键小于根结点，我们会返回该键在左子树中的排名（递归计算）；
// 如果给定的键大于根结点，我们会返回t+1（根结点）加上它在右子树中的排名（递归计算）。
- (int)__rank:(id)key node:(TreeNode *)node
{
    if (node == nil) {
        return 0;
    }
    int cmp = [key compare:node.key];
    if (cmp < 0) {
        // key 小于当前的node的key，即key在当前node的左子树中，返回的总排名 = 在左子树的排名
        return [self __rank:key node:node.left];
    } else if (cmp > 0) {
        // key大于当前的node的key，即key在当前node的右子树中，返回的总排名 = 左子树总数 +  1 （根） + 在右子树中的排名
        return [self __rank:key node:node.right] + 1 + node.left.size;
    } else {
        // 与当前的nodekey相当，直接返回左子树的size
        return node.left.size;
    }
}

#pragma mark Other

- (void)print:(PrintOrder)order
{
    _orderOutput = [@"" mutableCopy];
    if (order == PrePrintOrder) {
        [self preOrder];
    } else if(order == InPrintOrder) {
        [self inOrder];
    } else if (order == PostPrintOrder) {
        [self postOrder];
    } else if (order == LvevelPrintOrder) {
        [self levelOrder];
    }
    
    NSLog(@"%@", _orderOutput);
}

@end
