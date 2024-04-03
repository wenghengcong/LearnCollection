//
//  M_707_MyLinkedList.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/2.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

/*
 单链表中的节点应该具备两个属性：val 和 next 。val 是当前节点的值，next 是指向下一个节点的指针/引用。
 如果是双向链表，则还需要属性 prev 以指示链表中的上一个节点。假设链表中的所有节点下标从 0 开始。
 示例：
 输入
 ["MyLinkedList", "addAtHead", "addAtTail", "addAtIndex", "get", "deleteAtIndex", "get"]
 [[], [1], [3], [1, 2], [1], [1], [1]]
 输出
 [null, null, null, null, 2, null, 3]

 解释
 MyLinkedList myLinkedList = new MyLinkedList();
 myLinkedList.addAtHead(1);
 myLinkedList.addAtTail(3);
 myLinkedList.addAtIndex(1, 2);    // 链表变为 1->2->3
 myLinkedList.get(1);              // 返回 2
 myLinkedList.deleteAtIndex(1);    // 现在，链表变为 1->3
 myLinkedList.get(1);              // 返回 3
 */
public class M_707_MyLinkedList {
    var dummyHead: ListNodeGeneric<Int>?
    var size: Int
    
    init() {
        dummyHead = ListNodeGeneric(0)
        size = 0
    }
    
    /// 获取链表中下标为 index 的节点的值。如果下标无效，则返回 -1 。
    /// - Parameter index: 索引
    /// - Returns: 节点值
    func get(_ index: Int) -> Int {
        if (index < 0 || index > size-1) {
            return -1
        }
        var curNode = dummyHead?.next
        var curIndex = index

        while(curIndex > 0) {
            curNode = curNode?.next
            curIndex=curIndex-1
        }
        let val = curNode?.val ?? -1
        return val
    }
    
    /// 将一个值为 val 的节点插入到链表中第一个元素之前。在插入完成后，新节点会成为链表的第一个节点。
    /// - Parameter val: 需要插入的值
    func addAtHead(_ val: Int) {
        let newNode = ListNodeGeneric(val)
        let oriFirst = dummyHead?.next
        dummyHead?.next = newNode
        newNode.next = oriFirst
        size=size+1
    }
    
    /// 将一个值为 val 的节点追加到链表中作为链表的最后一个元素。
    /// - Parameter val: 需要插入的值
    func addAtTail(_ val: Int) {
        let newNode = ListNodeGeneric(val)
        var curNode = dummyHead
        while(curNode?.next != nil) {
            curNode = curNode?.next
        }
        curNode?.next = newNode
        size=size+1
    }
    
    /// 将一个值为 val 的节点插入到链表中下标为 index 的节点之前。如果 index 等于链表的长度，那么该节点会被追加到链表的末尾。
    /// 如果 index 比长度更大，该节点将 不会插入 到链表中。
    /// - Parameters:
    ///   - index: 索引
    ///   - val: 需要插入的值
    func addAtIndex(_ index: Int, _ val: Int) {
        if index > size {
            return
        }
        
        let newNode = ListNodeGeneric(val)
        
        var curNode = dummyHead
        var curIndex = index
        while(curIndex > 0) {
            curNode = curNode?.next
            curIndex = curIndex-1
        }
        newNode.next = curNode?.next
        curNode?.next = newNode
        size=size+1
    }
    
    /// 如果下标有效，则删除链表中下标为 index 的节点。
    /// - Parameter index: 需要删除的索引
    func deleteAtIndex(_ index: Int) {
        if index >= size || index < 0 {
            return
        }
        var curNode = dummyHead
        var curIndex = index
        while(curIndex > 0) {
            curNode = curNode?.next
            curIndex = curIndex-1
        }
        curNode?.next = curNode?.next?.next
        size=size-1
    }
}
