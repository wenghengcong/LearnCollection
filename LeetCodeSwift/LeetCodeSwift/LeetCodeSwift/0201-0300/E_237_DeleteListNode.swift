//
//  DeleteListNode.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/23.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/delete-node-in-a-linked-list/submissions/

/*
 请编写一个函数，使其可以删除某个链表中给定的（非末尾）节点，你将只被给定要求被删除的节点。
 说明:
 链表至少包含两个节点。
 链表中所有节点的值都是唯一的。
 给定的节点为非末尾节点并且一定是链表中的一个有效节点。
 不要从你的函数中返回任何结果。
 
 输入: head = [4,5,1,9], node = 5
 输出: [4,1,9]
 解释: 给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9.
 */
class E_237_DeleteListNode {
    class func deleteNode(_ node: ListNode) {
        node.val = node.next!.val
        node.next = node.next?.next
    }
}
