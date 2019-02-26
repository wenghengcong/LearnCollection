//
//  SortBase.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 所有排序，都是从小到大排序
 */
@interface SortBase : NSObject


/**
 针对array数组排序

 @param array 待排序的数组
 @param length 数组长度
 */
+ (void)sort:(int[])array length:(int)length;

/**
 交换数组中两个位置
 */
+ (void)swapWithA:(int *)a b:(int *)b;

/**
 打印一个数组
 */
+ (void)printArray:(int[])array length:(int)length;

@end

NS_ASSUME_NONNULL_END
