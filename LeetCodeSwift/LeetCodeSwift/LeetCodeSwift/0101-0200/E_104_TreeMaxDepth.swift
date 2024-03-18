//
//  TreeMaxDepth.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/15.
//  Copyright © 2019 LuCi. All rights reserved.
//

/*
 https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/solution/bfsdfsde-san-chong-fang-fa-by-darlingqiyue/
 
 给定一个二叉树，找出其最大深度。
 二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。
 说明: 叶子节点是指没有子节点的节点。
 */
import Foundation

class E_104_TreeMaxDepth {
    /*
      BFS：Breadth First Search 广度优先遍历
      是从根节点开始，沿着树的宽度遍历树的节点。如果所有节点均被访问，则算法中止。
     
      那么，怎样才能来保证这个访问的顺序呢？
      借助队列数据结构，由于队列先进先出的顺序。
      父节点入队，父节点出队列，先左子节点入队，后右子节点入队。递归遍历全部节点即可
    */
    
    
    
    /*
     DFS：Depth First Search
     是搜索算法的一种。它沿着树的深度遍历树的节点，尽可能深的搜索树的分支。
     当节点v的所有边都己被探寻过，搜索将回溯到发现节点v的那条边的起始节点。这一过程一直进行到已发现从源节点可达的所有节点为止。
     如果还存在未被发现的节点，则选择其中一个作为源节点并重复以上过程，整个进程反复进行直到所有节点都被访问为止。
     
     那么，怎么样才能来保证这个访问的顺序呢？
     分析一下，在遍历了根结点后，就开始遍历左子树，最后才是右子树。
     因此可以借助栈的数据结构，由于栈是后进先出的顺序。
     父节点入栈，父节点出栈，先右子节点入栈，后左子节点入栈。递归遍历全部节点即可
     */
    
    
    /// DFS：深度优先递归
    /// - Parameter root: <#root description#>
    class func maxDepth(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        let leftMax = maxDepth(root?.left)
        let rightMax = maxDepth(root?.right)
        return max(leftMax, rightMax) + 1
    }
    
    
    /// BFS：广度优先遍历
    /// - Parameter root: <#root description#>
    class func maxDepth_2(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
        
        var depth = 0
        var queue: [TreeNode] = []
        queue.append(root!)
        
        while !queue.isEmpty {
            depth = depth + 1
            for i in 0..<queue.count {
                // 将前面的出队
                let node = queue.remove(at: i)
                if node.left != nil {
                    queue.append(node.left!)
                }
                if node.right != nil {
                    queue.append(node.right!)
                }
            }
        }
        
        return depth
    }
    
    
    /// DFS: 深度优先遍历
    /// - Parameter root: <#root description#>
    class func maxDepth_3(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        }
         
        var stack: [(TreeNode?, Int)] = []
        var lastNode: (TreeNode?, Int) = (root, 1)
        stack.append(lastNode)
         
        var depth: Int = 0
         
        while !stack.isEmpty{
            // 先取出的是右节点，且继续将右节点的左、右节点入栈
            // 每次先取出右节点，所以直到将右节点取完后，才继续访问左节点
            lastNode = stack.removeLast()
            if depth < lastNode.1 {
                depth = lastNode.1
            }
            // 将左节点推入栈
            if lastNode.0?.left != nil{
                stack.append((lastNode.0?.left, lastNode.1 + 1))
            }
            // 将右节点推入栈
            if lastNode.0?.right != nil{
                stack.append((lastNode.0?.right, lastNode.1 + 1))
            }
        }
         
        return depth
    }
}
