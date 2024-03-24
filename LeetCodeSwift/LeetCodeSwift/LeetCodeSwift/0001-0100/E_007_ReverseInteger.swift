//
//  ReverseInteger.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/8.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/reverse-integer/
/// 给出一个 32 位的有符号整数，你需要将这个整数中每位上的数字进行反转。
class E_007_ReverseInteger {
    
    class func reverseEfficient( _ x: Int) -> Int {
        var result = 0
        var ori = x
        while ori != 0 {
            let pop = ori % 10
            ori = ori/10
            result = result * 10 + pop
        }
        if result > Int32.max || result < Int32.min {
            return 0
        }
        return result
    }
    
    class func reverse( _ x: Int) -> Int {
        var result = 0
        var nums: [Int] = []
        var ori = x
        while ori != 0 {
            let res = ori % 10
            nums.append(res)
            ori = ori/10
        }
        var n = nums.count
        for num in nums {
            if num != 0 {
                let mutiple: Int = Int(pow(Double(10),Double(n-1)))
                result = result + num * mutiple
            }
            n = n-1
        }
        if result > Int32.max || result < Int32.min {
            return 0
        }
        return result
    }
}
