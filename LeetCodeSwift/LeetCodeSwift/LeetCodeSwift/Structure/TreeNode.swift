//
//  TreeNode.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/15.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// 二叉树节点
public class TreeNode: Hashable {
    /// 二叉树节点值
    public var val: Int
    
    /// 左节点
    public var left: TreeNode?
    
    /// 右节点
    public var right: TreeNode?
    
    /// 初始化一个节点
    /// - Parameter val: 节点值
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        hasher.combine(left?.val)
        hasher.combine(right?.val)
    }
}

extension TreeNode: Equatable {
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        if lhs.val == rhs.val && lhs.right == rhs.right && lhs.left == rhs.left {
            return true
        }
        return false
    }
}
