//
//  E_209_MinSubArray.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/3/20.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

class E_209_MinSubArray {
    class func minSubArrayLen(_ s: Int, _ nums: [Int]) -> Int {
        var result = Int.max // 用于记录最小子数组长度，默认为 Int 最大值
        var sum = 0 // 滑动窗口数值之和
        var i = 0 // 滑动窗口起始位置
        var subLength = 0 // 滑动窗口的长度
        
        // 遍历数组中的每个元素
        for j in 0..<nums.count {
            sum += nums[j] // 将当前元素加入滑动窗口
            
            // 当滑动窗口内元素之和大于等于给定值 s 时，进入循环
            while sum >= s {
                subLength = j - i + 1 // 计算当前滑动窗口的长度
                result = min(result, subLength) // 更新最小子数组长度
                sum -= nums[i] // 移动滑动窗口的左边界，减去左边界的值
                i += 1 // 更新左边界的位置
            }
        }
        
        // 如果result没有被赋值的话，就返回0，说明没有符合条件的子序列
        return result == Int.max ? 0 : result
    }
}
