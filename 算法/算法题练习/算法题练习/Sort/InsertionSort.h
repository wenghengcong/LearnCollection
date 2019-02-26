//
//  InsertionSort.h
//  算法题练习
//
//  Created by WengHengcong on 2019/2/20.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortBase.h"

NS_ASSUME_NONNULL_BEGIN


/**
 插入排序
 
 算法思想
 
 算法步骤
 
 复杂度
 
 稳定性
 
 */
@interface InsertionSort : SortBase

+ (void)sort:(int[])array length:(int)length;


/**
 优化后的插入排序
 */
+ (void)sortOptimize:(int[])array length:(int)length;

@end

NS_ASSUME_NONNULL_END
