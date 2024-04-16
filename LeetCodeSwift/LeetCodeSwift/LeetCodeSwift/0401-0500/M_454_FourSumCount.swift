//
//  M_454_FourSumCount.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/16.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0454.%E5%9B%9B%E6%95%B0%E7%9B%B8%E5%8A%A0II.md
/// https://leetcode.cn/problems/4sum-ii/
class M_454_FourSumCount {
    
    /// 思路：将4组分为两两一组，即(a+b)+(c+d)=0
    func fourSumCount(_ nums1: [Int], _ nums2: [Int], _ nums3: [Int], _ nums4: [Int]) -> Int {
        var res = 0
        
        // 将n1\n2的和相加
        var n1n2sum: [Int: Int] = [:]
        for n1 in nums1 {
            for n2 in nums2 {
                let sum = n1+n2
                // 默认字典值来处理不存在的键，如果键不存在，则默认为0
                n1n2sum[sum, default: 0] += 1
            }
        }

        for n3 in nums3 {
            for n4 in nums4 {
                let sum = n3+n4
                let key = 0-sum
                res = res + n1n2sum[key, default: 0]
            }
        }
        
        return res
    }
}
