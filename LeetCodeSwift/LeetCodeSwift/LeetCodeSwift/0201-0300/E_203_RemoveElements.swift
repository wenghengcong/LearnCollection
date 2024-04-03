//
//  E_203_RemoveElements.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/2.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation


/* https://leetcode.cn/problems/remove-linked-list-elements/
 * https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0203.%E7%A7%BB%E9%99%A4%E9%93%BE%E8%A1%A8%E5%85%83%E7%B4%A0.md
 */
class E_203_RemoveElements {
    class func removeElements(_ head: ListNode?, _ val: Int) -> ListNode? {
        // 虚构一个头结点，如果删除的头结点，或者删除的是非头结点，都是统一处理，否则就会按removeElements_2方式处理
        let dummyHead = ListNode(0, head)
        var cur = dummyHead
        while cur.next != nil {
            if cur.next!.val == val {
                cur.next = cur.next?.next
            } else {
                cur = cur.next!
            }
        }
        let newHead = dummyHead.next
        return newHead
    }
    
    class func removeElements_2(_ head: ListNode?, _ val: Int) -> ListNode? {
        if head == nil {
            return nil
        }
        // 删除头结点
        var newHead = head
        while (newHead != nil && newHead!.val == val) { // 注意这里不是if
            newHead = newHead?.next;
        }
        
        // 删除非头结点
        var cur: ListNode = head!
        while cur.next != nil {
            if cur.next!.val == val {
                cur.next = cur.next?.next
            } else {
                cur = cur.next!
            }
        }
        return newHead
    }
}
