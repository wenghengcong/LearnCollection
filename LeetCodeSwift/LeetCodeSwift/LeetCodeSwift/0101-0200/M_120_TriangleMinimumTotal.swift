//
//  M_120_TriangleMiniumTotal.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2020/7/15.
//  Copyright © 2020 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/triangle/
/// 三角形最小路径和
class M_120_TriangleMinimumTotal {
    
    /// 给定一个三角形，找出自顶向下的最小路径和。每一步只能移动到下一行中相邻的结点上。相邻的结点 在这里指的是 下标 与 上一层结点下标 相同或者等于 上一层结点下标 + 1 的两个结点。
    /// - Parameter triangle: 三角形
    /// - Returns: 最小路径和
    class func minimumTotal(_ triangle: [[Int]]) -> Int {
        if triangle.count == 0 {
            return 0
        }
        return minimumTotalDFS(triangle, row: 0, column: 0)
    }
    
    /// 解法一：递归，从三角形顶部往下进行递归
    /// - Parameters:
    ///   - triangle: 三角形
    ///   - i: 行
    ///   - j: 列
    class func minimumTotalDFS(_ triangle: [[Int]], row i: Int, column j:Int) -> Int {
        if triangle.count == i {
            return 0
        }
        return min(minimumTotalDFS_2(triangle, row: i+1, column: j), minimumTotalDFS(triangle, row: i+1, column: j+1)) + triangle[i][j]
    }
    
    
    /// 解法二：递归+记忆
    /*
     时间复杂度：O(N^2)，N 为三角形的行数。
     空间复杂度：O(N^2)，N 为三角形的行数。
     */
    static var memo: [[Int]] = [[Int]]()
    class func minimumTotalDFS_2(_ triangle: [[Int]], row i: Int, column j:Int) -> Int {
        if memo.count == 0 {
            memo = [[Int]](repeating: [Int](repeating: 0, count: triangle.count), count: triangle.count)
        }
        
        if triangle.count == i {
            return 0
        }

        if memo[i][j] > 0 {
            return memo[i][j]
        }
        memo[i][j] =  min(minimumTotalDFS(triangle, row: i+1, column: j), minimumTotalDFS(triangle, row: i+1, column: j+1)) + triangle[i][j]
        return memo[i][j]
    }
    
    
    /// 解法三：动态规划
    /*
     定义二维 dp 数组，将解法二中「自顶向下的递归」改为「自底向上的递推」。
     dp[i][j] 表示从点 (i, j)(i,j) 到底边的最小路径和。
     状态转移：
     dp[i][j]=min(dp[i+1][j],dp[i+1][j+1])+triangle[i][j]
     时间复杂度：O(N^2)，N 为三角形的行数。
     空间复杂度：O(N^2)，N 为三角形的行数。
     */
    class func minimumTotalQuickly(_ triangle: [[Int]]) -> Int {
        let size = triangle.count
        // dp[i][j] 表示从点 (i, j) 到底边的最小路径和。
        var dp: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: size+1), count: size+1)
        // 从三角形的最后一行开始递推。
        for i in (0...size-1).reversed() {
            for j in 0...i {
                dp[i][j] = min(dp[i+1][j], dp[i+1][j+1]) + triangle[i][j]
            }
        }
        return dp[0][0]
    }
    
    
    /// 解法四：动态规划+节省空间
    /*
     在上述代码中，我们定义了一个 N 行 N 列 的 dp 数组（NN 是三角形的行数）。
     但是在实际递推中我们发现，计算 dp[i][j] 时，只用到了下一行的 dp[i + 1][j] 和 dp[i + 1][j + 1]。
     因此 dp 数组不需要定义 N 行，只要定义 1 就可以。
     所以我们稍微修改一下上述代码，将 i 所在的维度去掉（如下），就可以将 O(N^2) 的空间复杂度优化成 O(N)
     */
    class func minimumTotalQuickly_2(_ triangle: [[Int]]) -> Int {
        let size = triangle.count
        // dp[i][j] 表示从点 (i, j) 到底边的最小路径和。
        var dp: [Int] = [Int](repeating: 0, count: size+1)
        // 从三角形的最后一行开始递推。
        for i in (0...size-1).reversed() {
            for j in 0...i {
                dp[j] = min(dp[j], dp[j+1]) + triangle[i][j]
            }
        }
        return dp[0]
    }
}
