//
//  MissingNumber.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/20.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/missing-number/
/// 给定一个包含 0, 1, 2, ..., n 中 n 个数的序列，找出 0 .. n 中没有出现在序列中的那个数。
class E_268_MissingNumber {
    /*
     index 是从0到n-1的序列
     numbs如果不缺失，应该十从0到n的序列
     两者相减即为缺失的数字。
     通过一次迭代来做
     */
    class func missingNumber(_ nums: [Int]) -> Int {
        var missed = nums.count
        for (index, num) in nums.enumerated() {
            missed = missed + (index - num)
        }
        return missed
    }
    
    /*
     其他方法：
     1. 哈希表，两次循环，一次循环将0...n存储到哈希表，一次查找numbs，找到不在哈希表的那个数即可
     2. 数学：0...n的总和为：n(n+1)/2，丢失的即为总和减去nums总和
     3.异或运算：由于异或运算（XOR）满足结合律，并且对一个数进行两次完全相同的异或运算会得到原来的数，
        因此我们可以通过异或运算找到缺失的数字。
     */
}
