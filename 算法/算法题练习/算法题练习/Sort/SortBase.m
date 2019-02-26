//
//  SortBase.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SortBase.h"

@implementation SortBase

+ (void)sort:(int [])array length:(int)length
{
    
}

+ (void)swapWithA:(int *)a b:(int *)b
{
    int temp = *b;
    *b = *a;
    *a = temp;
}

+ (void)printArray:(int[])array length:(int)length
{
    NSMutableString *output = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [output appendString:[NSString stringWithFormat:@" %d", array[i]]];
    }
    NSLog(@"sorted array: %@", output);
}

@end
