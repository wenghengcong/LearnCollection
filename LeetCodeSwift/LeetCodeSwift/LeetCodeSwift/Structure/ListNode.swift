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
        self.next = nil
    }
}
