//
//  Stack.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"

NS_ASSUME_NONNULL_BEGIN


/**
 栈：先进后出
 任何进行逆序的都可以考虑到栈这种结构
 */
@interface Stack<__covariant ObjectType> : NSObject

/**
 栈顶
 */
@property (nonatomic, strong, nullable) ListNode<ObjectType> *top;

@property (nonatomic, assign) int     size;

- (instancetype)initWithArray:(int[])array length:(int)length;
+ (instancetype)stackWithArray:(int[])array length:(int)length;

- (void)push:(ListNode *)item;
- (void)pushValue:(ObjectType)value;


- (nullable ListNode *)pop;
- (nullable ObjectType)popValue;

- (nullable ListNode *)peek;
- (nullable ObjectType)peekValue;


- (BOOL)isEmpty;
- (void)print;

@end

NS_ASSUME_NONNULL_END
