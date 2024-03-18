//
//  E_198_Rob.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/26.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/house-robber/
/*
 你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素
 就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。
 给定一个代表每个房屋存放金额的非负整数数组，计算你在不触动警报装置的情况下，能够偷窃到的最高金额。
 
 输入: [2,7,9,3,1]
 输出: 12
 解释: 偷窃 1 号房屋 (金额 = 2), 偷窃 3 号房屋 (金额 = 9)，接着偷窃 5 号房屋 (金额 = 1)。
           偷窃到的最高金额 = 2 + 9 + 1 = 12 。
 */
class E_198_Rob {
    
    /// 动态规划
    /// 记录f[k] 即从前k个房间里能抢到最大的金额，Ai = 第 i 个房屋的钱数
    ///  n = 1,     f(1) = A1
    ///  n = 2,     f(2) = max(A1,A2)
    ///  n = 3,     f(3) 有两种方式：
    ///      1. 抢第三个房子，将数额与第一个房子相加
    ///      2. 不抢第三个房子，保持f(2)现有最大数额
    ///  n = 4,     f(4)也可以选择两种方式：
    ///      1.抢第四个房子，将f(2)与之相加
    ///      2.不抢第四个房子，保持f(3)的金额
    ///      即动态规划的公式为：
    ///      f(k) = max(    f(k-2))+Ak,     f(k-1)      )
    /// - Parameter nums: 每个房间里的钱
    class func rob(_ nums: [Int]) -> Int {
        var curMax = 0, preMax = 0
        for num in nums {
            let temp = curMax
            curMax = max(preMax + num, curMax)
            preMax = temp
        }
        
        return curMax
    }
}
