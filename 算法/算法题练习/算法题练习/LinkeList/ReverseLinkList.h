//
//  ReverseLinkList.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/26.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "TypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

/**
 剑指Offer 面试题6：从尾到头打印链表
 */
@interface ReverseLinkList : TypeHeader

+ (void)reverseLinkList:(SingleLinkedList *)list;

+ (void)reverseLinkListOptimize:(SingleLinkedList *)list;

@end

NS_ASSUME_NONNULL_END
