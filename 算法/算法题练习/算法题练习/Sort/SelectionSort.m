//
//  SelectionSort.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SelectionSort.h"

@implementation SelectionSort


+ (void)sort:(int[])array length:(int)length
{
    for (int i = 0; i < length; i++) {
        int minIndex = i;
        for (int j = i; j < length; j++) {
            if (array[j] < array[minIndex]) {
                minIndex = j;
            }
            if (minIndex != i) {
                [self swapWithA:&array[minIndex] b:&array[i]];
            }
        }
      
    }
    [self printArray:array length:length];
}

@end
