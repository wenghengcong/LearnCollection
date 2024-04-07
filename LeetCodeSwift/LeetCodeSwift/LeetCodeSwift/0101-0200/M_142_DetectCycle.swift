//
//  M_142_DetectCycle.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/6.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode.cn/problems/linked-list-cycle-ii/
/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0142.%E7%8E%AF%E5%BD%A2%E9%93%BE%E8%A1%A8II.md
class M_142_DetectCycle {
    
    class func detectCycle(_ head: ListNode?) -> ListNode? {
        var fast = head
        var slow = head
        while (fast != nil && fast?.next != nil) {
            fast = fast?.next?.next
            slow = slow?.next
            if fast === slow {   // 有环
                var index1 = fast
                var index2 = head
                while index1 !== index2 {
                    index1 = index1?.next
                    index2 = index2?.next
                }
                return index2   // 返回环的入口
            }
        }
        return nil
    }
}
