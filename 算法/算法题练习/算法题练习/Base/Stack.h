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

@interface Stack<__covariant ObjectType> : NSObject

/**
 栈顶
 */
@property (nonatomic, strong, nullable) Node<ObjectType> *top;

@property (nonatomic, assign) NSInteger     size;

- (instancetype)init;

- (void)push:(Node *)item;
- (void)pushValue:(ObjectType)value;


- (nullable Node *)pop;
- (nullable ObjectType)popValue;

- (nullable Node *)peek;
- (nullable ObjectType)peekValue;


- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
