//
//  ReverseLinkList.m
//  算法题练习
//
//  Created by WengHengcong on 2019/1/26.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ReverseLinkList.h"

@implementation ReverseLinkList

+ (void)reverseLinkList:(SingleLinkedList *)list
{
    if (list == nil || list.size == 0) {
        return;
    }
    
    Stack *st = [[Stack alloc] init];
    ListNode *current = list.head;
    while (current != nil) {
        [st push:current];
        current = current.next;
    }
    
    [st print];
}


/**
 递归本质上就是一个栈
 */
+ (void)reverseLinkListOptimize:(SingleLinkedList *)list
{
    if (list != nil) {
        [self reverseLinkListByHead:list.head];
    }
}

+ (void)reverseLinkListByHead:(ListNode *)node
{
    if (node != nil) {
        [self reverseLinkListByHead:node.next];
        NSLog(@"%@", node.value);
    }
}

@end
