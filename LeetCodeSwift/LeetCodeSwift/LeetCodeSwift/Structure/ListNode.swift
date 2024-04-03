//
//  ListNode.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/13.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    
    public init(_ val: Int) {
        self.val = val;
        self.next = nil;
    }
    
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val;
        self.next = next;
    }
    
    public func printAllNode() {
        var nodesStr = "\(self.val)"
        var nextNode = self.next
        while nextNode != nil {
            let nextVal = nextNode!.val
            nodesStr = nodesStr + "-\(nextVal)"
            nextNode = nextNode?.next
        }
        if nodesStr.isEmpty {
            nodesStr = "[]"
        }
        print("nodes: \(nodesStr)")
    }
}


public class ListNodeGeneric<T> {
    public var val: T
    public var next: ListNodeGeneric?
    
    public init(_ val: T) {
        self.val = val;
        self.next = nil;
    }
    
    public init(_ val: T, _ next: ListNodeGeneric?) {
        self.val = val;
        self.next = next;
    }
    
    public func printAllNode() {
        var nodesStr = "\(self.val)"
        var nextNode = self.next
        while nextNode != nil {
            let nextVal = nextNode!.val
            nodesStr = nodesStr + "-\(nextVal)"
            nextNode = nextNode?.next
        }
        if nodesStr.isEmpty {
            nodesStr = "[]"
        }
        print("nodes: \(nodesStr)")
    }
}
