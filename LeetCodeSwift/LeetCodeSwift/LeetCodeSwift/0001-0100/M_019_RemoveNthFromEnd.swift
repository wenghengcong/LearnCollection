//
//  M_019_RemoveNthFromEnd.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode.cn/problems/remove-nth-node-from-end-of-list/description/
/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0019.%E5%88%A0%E9%99%A4%E9%93%BE%E8%A1%A8%E7%9A%84%E5%80%92%E6%95%B0%E7%AC%ACN%E4%B8%AA%E8%8A%82%E7%82%B9.md
class M_019_RemoveNthFromEnd {
    class func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
            guard head != nil else {
                return nil
            }
            guard n != 0 else {
                return head
            }
            // 虚拟头结点方便删除头结点的特殊情况
            let dummyHead = ListNode(-1)
            dummyHead.next = head

            var slow: ListNode? = dummyHead
            var fast: ListNode? = dummyHead

            // 将快指针移动 n+1 步，为什么是n+1呢，因为只有这样同时移动的时候slow才能指向删除节点的上一个节点（方便做删除操作）
            for _ in 0 ..< n {
                fast = fast?.next
            }

            // 移动快慢指针，如果快指针移动到最后nil，那么慢指针，刚好在删除节点的上一个节点
            while fast?.next != nil {
                slow = slow?.next
                fast = fast?.next
            }

            // 删除倒数第 n 个结点
            slow?.next = slow?.next?.next
            return dummyHead.next
        }
}
