//
//  main.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinarySearch.h"
#import "Search/SelectionSort.h"

int sortedArr[10] = {2, 3, 5, 8, 11, 34, 45, 89, 100, 122};
int disorderArr[10] = {11, 2, 3, 34, 8, 122, 45, 5, 89, 100};
int length = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [SelectionSort selectionSort:disorderArr length:length];
    }
    return 0;
}

void binarySearch()
{
    int search = [BinarySearch binarySearchByKey:11 array:sortedArr length:length];
    int search2 = [BinarySearch binarySearchByKey:100 array:sortedArr lower:0 high:length];
    NSLog(@"%d", search2);
}
