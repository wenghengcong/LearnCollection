//
//  InsertionSort.m
//  算法题练习
//
//  Created by WengHengcong on 2019/2/20.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "InsertionSort.h"

@implementation InsertionSort

+ (void)sort:(int[])array length:(int)length
{
    for (int i = 1; i < length; i++) {
        for (int j = i; j > 0; j--) {
            if (array[j] < array[j-1]) {
                [self swapWithA:&array[j] b:&array[j-1]];;
            }
        }
    }
}

+ (void)sortOptimize:(int[])array length:(int)length
{
    for (int i = 0; i < length; i++) {
        int e = array[i];
        int j;
        for (j = i; array[j-1] > e; j--) {
            array[j] = array[j-1];
        }
        array[j] = e;
    }
}

@end
