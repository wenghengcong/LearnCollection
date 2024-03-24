//
//  E_136_SingleNumber.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/26.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/single-number/
/*
 给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。
 找出那个只出现了一次的元素。
 说明：你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？
 */
class E_136_SingleNumber {
    
    class func singleNumber(_ nums: [Int]) -> Int {
        var single = 0
        for n in nums {
            single = single ^ n
        }
        return single
    }
    /*
     也可以用哈希表来计数或者判断是否存在
     */
}
