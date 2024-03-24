//
//  ClimbStairs.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/14.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/climbing-stairs/
/// 假设你正在爬楼梯。需要 n 阶你才能到达楼顶。每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？
class E_070_ClimbStairs {
    
    /*
     方法一：
     我们将会把所有可能爬的阶数进行组合，也就是 1 和 2 。而在每一步中我们都会继续调用 climbStairs 这个函数模拟爬 1 阶和 2 阶的情形，并返回两个函数的返回值之和。
            climbStairs(i,n) = climbStairs(i + 1, n) + climbStairs(i + 2, n)
     其中 i 定义了当前阶数，而 n 定义了目标阶数。
     */
    class func climbStairs_1(_ n: Int) -> Int {
        return climb_Stairs_1(0, n)
    }
    
    
    /// 模拟爬楼梯的动作
    /// - Parameter i: 当前所在的台阶
    /// - Parameter n: 将要到达的台阶
    class func climb_Stairs_1(_ i: Int, _ n: Int) -> Int {
        if i > n {
            return 0
        }
        if i == n {
            return 1
        }
        
        return climb_Stairs_1(i+1, n) + climb_Stairs_1(i+2, n)
    }
    
    
    
    /*
     方法二：
     在上一种方法中，我们计算每一步的结果时出现了冗余。另一种思路是，我们可以把每一步的结果存储在 memo 数组之中，每当函数再次被调用，我们就直接从 memo 数组返回结果。
     在 memo 数组的帮助下，我们得到了一个修复的递归树，其大小减少到 n。
     */
    class func climbStairs_2(_ n: Int) -> Int {
        var memo = [Int].init(repeating: 0, count: n+1)
        return climb_Stairs_2(0, n, &memo)
    }
    
    class func climb_Stairs_2(_ i: Int, _ n: Int, _ memo: inout [Int]) -> Int {
        if i > n {
            return 0
        }
        if i == n {
            return 1
        }
        
        if memo[i] > 0 {
            return memo[i]
        }
        
        memo[i] = climb_Stairs_2(i+1, n, &memo) + climb_Stairs_2(i+2, n, &memo)
        return memo[i]
    }
    
    
    /*
     方法三：动态规划
     问题可以被分解为一些包含最优子结构的子问题，即它的最优解可以从其子问题的最优解来有效地构建，可使用动态规划来解决。
     第 ii 阶可以由以下两种方法得到：
        * 在第 (i-1) 阶后向上爬一阶。
        * 在第 (i-2) 阶后向上爬 2 阶。
     所以到达第 i 阶的方法总数就是到第 (i−1) 阶和第 (i−2) 阶的方法数之和。
     令 dp[i] 表示能到达第 i 阶的方法总数：
        dp[i]=dp[i-1]+dp[i-2]
     */
    class func climbStairs_3(_ n: Int) -> Int {
        if n < 3 {
            return n
        }
        
        var dp = [Int].init(repeating: 0, count: n+1)
        dp[1] = 1
        dp[2] = 2
        for i in 3...n {
            dp[i] = dp[i-1] + dp[i-2]
        }
        return dp[n]
    }
    
    
    /*
     方法四：斐波那契数列
     在上述方法中，我们使用 dp 数组，其中 dp[i]=dp[i-1]+dp[i-2]
     可以很容易通过分析得出 dp[i] 其实就是第 i 个斐波那契数。
        Fib(n)=Fib(n-1)+Fib(n-2)
     现在我们必须找出以 1 和 2 作为第一项和第二项的斐波那契数列中的第 n 个数，
     也就是说 Fib(1)=1Fib(1)=1 且 Fib(2)=2
     */
    class func climbStairs_4(_ n: Int) -> Int {
        if n < 3 {
            return n
        }
        var first = 1
        var second = 2
        for _ in 3...n {
            let third = first + second
            first = second
            second = third
        }
        return second
    }
    
    
    /*
     方法五：斐波那契数列公式
    */
    class func climbStairs_5(_ n: Int) -> Int {
        let sqrt_5 = sqrt(5)
        let fib_N = pow( (1+sqrt_5)/2, Double(n+1)) - pow( (1-sqrt_5)/2, Double(n+1))
        let result = fib_N/sqrt_5
        return Int(result)
    }
}
