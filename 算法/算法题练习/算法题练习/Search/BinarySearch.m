//
//  BinarySearch.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BinarySearch.h"

@implementation BinarySearch


/**
 在array数组中查找key
 */
+ (int)binarySearchByKey:(int)key array:(int[])array length:(int)length;
{
    int lo = 0;
    int hi = length-1;
    // 在[lo...hi]中查找该关键字
    while (lo <= hi) {
        int mid = lo + (hi-lo)/2;
        if (key < array[mid] ) {
            hi = mid - 1;
        } else if(key > array[mid]) {
            lo = mid + 1;
        } else {
            return mid;
        }
    }
    return -1;
}

+ (int)binarySearchByKey:(int)key array:(int [])array lower:(int)lo high:(int)hi
{
    int mid = lo + (hi-lo)/2;
    if (key < array[mid]) {
        int high = mid - 1;
        return [self binarySearchByKey:key array:array lower:lo high:high];
    } else if(key > array[mid]) {
        int lower = mid + 1;
        return [self binarySearchByKey:key array:array lower:lower high:hi];
    } else {
        return mid;
    }
    
    return -1;
}


@end
