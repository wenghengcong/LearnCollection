//
//  BubbleSort.m
//  算法题练习
//
//  Created by WengHengcong on 2019/2/26.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BubbleSort.h"

@implementation BubbleSort

+ (void)sort:(int [])array length:(int)length
{
    // 遍历外层循环，每一次将第i个数字移动到特定位置
    for (int i = 0; i < length-1; i++) {
        // 内层循环，将第i个数字，逐次比较
        // 如果j大于j+1，就移动到后面
        for (int j = 0; j < length-i-1; j++) {
            if (array[j] > array[j+1]) {
                [self swapWithA:&array[j] b:&array[j+1]];
            }
        }
    }
}

@end
