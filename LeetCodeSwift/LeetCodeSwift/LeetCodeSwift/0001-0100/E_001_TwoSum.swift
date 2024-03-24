//
//  TwoSum.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/6.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/// 两数之和：https://leetcode-cn.com/problems/two-sum/
class E_001_TwoSum {
    
    class func twoSumEfficient(_ nums: [Int], _ target: Int) -> [Int] {
        var container: [Int: Int] = [:]
        for (index, value) in nums.enumerated() {
            let match = target - value
            if container.keys.contains(match) && container[match]! != index {
                return [container[match]!, index]
            }
            container[value] = index
        }
        return [0, 0]
    }
    
    class func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        let count = nums.count
//        for i in stride(from: 1, to: count, by: 1)
        for i in 0...count {
            for j in i+1...count {
                if nums[i] + nums[j] == target {
                    return [j, i]
                }
            }
        }
        
        return [0, 0]
    }
    
    
}
