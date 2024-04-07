//
//  M_024_SwapPairs.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/3.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */

/// leetcode: https://leetcode.cn/problems/swap-nodes-in-pairs/
/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0024.%E4%B8%A4%E4%B8%A4%E4%BA%A4%E6%8D%A2%E9%93%BE%E8%A1%A8%E4%B8%AD%E7%9A%84%E8%8A%82%E7%82%B9.md
class M_024_SwapPairs {
    class func swapPairs(_ head: ListNode?) -> ListNode? {
        let dummyHead = ListNode(0)
        dummyHead.next = head
        
        // 如果原来节点顺序是：cur-1-2-3，交换后应该是cur-2-1-3
        // cur.next = 2,2.next=1,1.next=3 三个步骤
        var cur:ListNode? = dummyHead
        while cur?.next != nil && cur?.next?.next != nil {
            // 注意此处的判空条件，因为cur是在两个交换节点的前一个位置
            // 所以，如果需要较好，那么cur.next和cur.next.next必须非空
            let first = cur?.next       // cur后的第一个节点
            let sec = cur?.next?.next   // cur后的第二个节点
            let third = cur?.next?.next?.next    // cur后的第三个节点

            cur?.next = sec
            sec?.next = first
            first?.next = third
            cur = cur?.next?.next
        }
        return dummyHead.next
    }
}
