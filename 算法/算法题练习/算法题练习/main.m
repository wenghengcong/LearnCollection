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
#import "TypeHeader.h"
#import "LinkeList/ReverseLinkList.h"

int sortedArr[10] = {2, 3, 5, 8, 11, 34, 45, 89, 100, 122};
int disorderArr[10] = {11, 2, 3, 34, 8, 122, 45, 5, 89, 100};
int length = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Queue *queue = [Queue queueWithArray:disorderArr length:10];
        [queue print];
        
        Stack *st = [Stack stackWithArray:disorderArr length:10];
        [st print];
        
        LinkList *list = [LinkList linkListWithArray:disorderArr length:10];
        [list removeValue:@11];
        [list print];
        
        [ReverseLinkList reverseLinkList:list];
        [ReverseLinkList reverseLinkListOptimize:list];
    }
    return 0;
}

void sort()
{
    [SelectionSort selectionSort:disorderArr length:length];
}

void binarySearch()
{
    int search = [BinarySearch binarySearchByKey:11 array:sortedArr length:length];
    int search2 = [BinarySearch binarySearchByKey:100 array:sortedArr lower:0 high:length];
    NSLog(@"%d", search2);
}
