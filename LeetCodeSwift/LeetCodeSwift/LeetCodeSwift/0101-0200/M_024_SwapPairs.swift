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
class Solution {
    func swapPairs(_ head: ListNode?) -> ListNode? {
        let dummyHead = ListNode(0)
        dummyHead.next = head
        
        var cur = dummyHead
        while cur.next != nil && cur.next?.next != nil {
            let first = cur.next!
            let sec = cur.next!.next!
            
            cur.next = sec
            sec.next = first
            first.next = sec.next
            cur = cur.next!.next!
        }
        return dummyHead.next
    }
}
