//
//  SelectionSort.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortBase.h"

NS_ASSUME_NONNULL_BEGIN


/**
 算法思想
    选择排序(Selection-sort)是一种简单直观的排序算法。它的工作原理：首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置，然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。以此类推，直到所有元素均排序完毕。
 
 算法步骤
 
 复杂度
 
 稳定性
 
 
 */
@interface SelectionSort : SortBase

+ (void)sort:(int[])array length:(int)length;

@end

NS_ASSUME_NONNULL_END
