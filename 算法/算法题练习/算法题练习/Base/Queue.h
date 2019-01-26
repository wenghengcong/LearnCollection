//
//  Queue.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 先进先出
 */
@interface Queue<__covariant ObjectType> : NSObject

@property (nonatomic, strong) Node<ObjectType> *first;
@property (nonatomic, strong) Node<ObjectType> *last;

@property (nonatomic, assign) int size;

- (instancetype)initWithArray:(int[])array length:(int)length;
+ (instancetype)queueWithArray:(int[])array length:(int)length;


- (void)enQueue:(Node *)item;
- (void)enQueueWithValue:(ObjectType)value;


- (nullable Node *)deQueue;
- (nullable ObjectType)deQueueValue;

- (nullable Node *)peek;
- (nullable ObjectType)peekValue;


- (BOOL)isEmpty;
- (void)print;

@end

NS_ASSUME_NONNULL_END
