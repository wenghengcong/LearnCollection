//
//  MergeTwoLists.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/13.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

class E_021_MergeTwoLists {
    class func mergeTwoListsEffecient(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        if l1 == nil && l2 == nil {
              return nil
          }
          
          if l1 == nil {
              return l2
          }
          
          if l2 == nil {
              return l1
          }
          
          let newHead: ListNode?
          if l1!.val > l2!.val {
              newHead = l2
              newHead?.next = mergeTwoLists(l2?.next, l1)
          } else {
              newHead = l1
              newHead?.next = mergeTwoLists(l1?.next, l2)
          }
          
          return newHead
    }
    
    class func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var l1_p = l1
        var l2_p = l2
        // 设置帽子节点，可以省去判空操作
        let newList = ListNode(0)
        // 用于遍历
        var tmpNode: ListNode? = newList
        while l1_p != nil && l2_p != nil {
            if l1_p!.val < l2_p!.val {
                tmpNode?.next = l1_p
                l1_p = l1_p?.next
            } else {
                tmpNode?.next = l2_p
                l2_p = l2_p?.next
            }
            tmpNode = tmpNode?.next
        }
        tmpNode?.next = (l1_p != nil) ? l1_p : l2_p
        return newList.next
    }
}
