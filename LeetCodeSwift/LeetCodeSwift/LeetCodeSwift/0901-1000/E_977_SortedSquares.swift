//
//  E_977_SortedSquares.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/3/19.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation
/// https://leetcode.cn/problems/squares-of-a-sorted-array/description/
/// 思考，如何不使用左右两值的平方判定是左边值大还是右边值大
/// 利用加法
class E_977_SortedSquares {
    
    class  func sortedSquares_01(_ nums: [Int]) -> [Int] {
        guard nums.count > 0 else {
            return []
        }
        var leftIndex = 0
        var rightIndex = nums.count-1
        
        var result: [Int] = [Int](repeating: 0, count: nums.count)
        var resultIndex = rightIndex
        
        while(leftIndex<=rightIndex) {
            let leftNum = nums[leftIndex]*nums[leftIndex]
            let rightNum = nums[rightIndex]*nums[rightIndex]
            if leftNum >= rightNum {
                result[resultIndex] = leftNum
                leftIndex += 1
                resultIndex -= 1
            } else if leftNum < rightNum {
                result[resultIndex] = rightNum
                rightIndex -= 1
                resultIndex -= 1
            }
        }
        return result
    }
    
    class  func sortedSquares_02(_ nums: [Int]) -> [Int] {
        guard nums.count > 0 else {
            return []
        }
        let size = nums.count
        var result = [Int](repeating: -1, count: size)
        
        var i = 0
        var k = size-1
        var j = size-1
        for _ in 0..<size {
            if(nums[i] * nums[i] < nums[j] * nums[j]) {
                result[k] = nums[j] * nums[j]
                j = j-1
            } else {
                result[k] = nums[i] * nums[i]
                i = i+1
            }
            k = k-1
        }
        return result
    }
}
