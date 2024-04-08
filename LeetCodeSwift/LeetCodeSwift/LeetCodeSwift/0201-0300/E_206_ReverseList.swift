//
//  ReverseList.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/23.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/reverse-linked-list/solution/fan-zhuan-lian-biao-by-leetcode/
/*
反转一个单链表。
示例:
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
*/
class E_206_ReverseList {
    
    /// 双指针
    /// - Parameter head: 头结点
    /// - Returns: 翻转后的头结点
    class func reverseList(_ head: ListNode?) -> ListNode? {
        var pre: ListNode? = nil
        var cur = head
        
        while cur != nil {
            let nextTemp = cur?.next   // 保存一下 cur的下一个节点，因为接下来要改变cur->next
            cur?.next = pre   // 翻转操作
            // 更新pre和cur
            pre = cur
            cur = nextTemp
        }
        
        return pre
    }
    
    /// 递归
    /// - Parameter head: 头结点
    /// - Returns: 翻转后的链表头结点
    func reverseList2(_ head: ListNode?) -> ListNode? {
        return reverse(pre: nil, cur: head)
    }
    
    func reverse(pre: ListNode?, cur: ListNode?) -> ListNode? {
        if cur == nil {
            return pre
        }
        let temp: ListNode? = cur?.next
        cur?.next = pre
        return reverse(pre: cur, cur: temp)
    }
}
