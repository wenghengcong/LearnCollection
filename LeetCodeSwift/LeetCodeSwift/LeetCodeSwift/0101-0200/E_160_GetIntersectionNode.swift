//
//  E_160_GetIntersectionNode.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation



/// https://leetcode.cn/problems/intersection-of-two-linked-lists/
/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/%E9%9D%A2%E8%AF%95%E9%A2%9802.07.%E9%93%BE%E8%A1%A8%E7%9B%B8%E4%BA%A4.md
class E_160_GetIntersectionNode {
    class func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        guard (headA != nil || headB != nil) else {
            return nil
        }

        // 获取A\B长度
        var lenA = 0
        var curA = headA
        while curA?.next != nil {
            lenA=lenA+1
            curA = curA?.next
        }

        var lenB = 0
        var curB = headB
        while curB?.next != nil {
            lenB=lenB+1
            curB = curB?.next
        }
        
        // 比较A\B的长度，确定哪个更长，需要将更长的那个递进abs(lenA-lenB)步，对齐
        var gap = 0
        var bigSizeHead: ListNode?
        var smallSizeHead: ListNode?
        if lenA > lenB {
            gap = lenA-lenB
            bigSizeHead = headA
            smallSizeHead = headB
        } else {
            gap = lenB-lenA
            bigSizeHead = headB
            smallSizeHead = headA
        }
        // 递进gap步
        while gap > 0 {
            bigSizeHead=bigSizeHead?.next
            gap = gap-1
        }
        // 判定两个是否有相同的交点
        while bigSizeHead !== smallSizeHead  {
            bigSizeHead = bigSizeHead?.next
            smallSizeHead = smallSizeHead?.next
        }
        return bigSizeHead
    }


    /// 快慢指针解法
    /// https://leetcode.cn/problems/intersection-of-two-linked-lists/solutions/156198/gei-zi-ji-liu-ge-bi-ji-by-kkbill/
    class func getIntersectionNode_2(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        guard (headA != nil || headB != nil) else {
            return nil
        }
        var pA = headA, pB = headB
        while (pA !== pB) {
            pA = (pA == nil) ? headB : pA?.next;
            pB = (pB == nil) ? headA : pB?.next;
        }
        return pA;
    }
}
