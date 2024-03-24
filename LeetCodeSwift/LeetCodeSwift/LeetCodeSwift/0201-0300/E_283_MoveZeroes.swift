//
//  MoveZeroes.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/20.
//  Copyright © 2019 LuCi. All rights reserved.
//


import Foundation

/// https://leetcode-cn.com/problems/move-zeroes/
/// 给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。
class E_283_MoveZeroes {
    class func moveZeroesEffecient(_ nums: inout [Int]) {
        var index = 0
        var count = nums.count
        var zeroNum = 0
        while index <= count-1 {
            if nums[index] == 0 {
                nums.remove(at: index)
                count -= 1
                zeroNum += 1
            } else {
                index += 1
            }
        }
        if zeroNum > 0 {
            nums.append(contentsOf: Array.init(repeating: 0, count: zeroNum))
        }
    }

    /*
     声明一个慢指针，表示当前指向的 下一个非0数 插入的位置；用 快指针 遍历一遍数组：
        1. 遇到 非0数，则将其插入慢指针的位置，然后将慢指针 后移一位
        2. 遇到 0，则跳过考虑下一位。
     如此当快指针遍历完数组后，所有 非0数 已经归位，随后将 慢指针 及其之后的位置设置为0即可。
     */
    class func moveZeroes(_ nums: inout [Int]) {
        var lastNonZeroFoundAt = 0
        for num in nums {
            if num != 0 {
                nums[lastNonZeroFoundAt] = num
                lastNonZeroFoundAt = lastNonZeroFoundAt + 1
            }
        }
        
        for i in lastNonZeroFoundAt..<nums.count {
            nums[i] = 0
        }
    }
}
