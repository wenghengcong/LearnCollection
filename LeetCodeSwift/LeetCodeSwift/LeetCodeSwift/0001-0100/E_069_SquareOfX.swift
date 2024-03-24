//
//  SquareOfX.swift
//  LeetCodeSwift
//
//  Created by Qiu on 2019/8/14.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/sqrtx/
/*
 实现 int sqrt(int x) 函数。
 计算并返回 x 的平方根，其中 x 是非负整数。
 由于返回类型是整数，结果只保留整数的部分，小数部分将被舍去。
 */
class E_069_SquareOfX {
    /// 牛顿法
    /*
     使用牛顿法可以得到一个正实数的算术平方根，因为题目中说“结果只保留整数部分”，因此，我们把使用牛顿法得到的浮点数转换为整数即可。
     牛顿法的思想：在迭代过程中，以直线代替曲线，用一阶泰勒展式（即在当前点的切线）代替原曲线，求直线与 xx 轴的交点，重复这个过程直到收敛
     */
    /// - Parameter x: <#x description#>
    class func mySqrtEffecient(_ x: Int) -> Int {
        var iter = x
        while iter * iter > x {
            iter = (x + iter/x)/2
        }
        return x
    }
    
    
    /// 二分查找法
    /// 使用二分法搜索平方根的思想很简单，就类似于小时候我们看的电视节目中的“猜价格”游戏，
    /// 高了就往低了猜，低了就往高了猜，范围越来越小。因此，使用二分法猜算术平方根就很自然。
    /// - Parameter x:
    class func mySqrt(_ x: Int) -> Int {
        if x == 0 || x==1 {
            return x
        }
        var left = 0
        var right = x/2 + 1
        while left < right {
            let mid = left + (right - left + 1)/2
            let square = mid * mid
            if square > x {
                right = mid - 1
            } else {
                left = mid
            }
        }
        return left
    }
}
