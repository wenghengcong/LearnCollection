//
//  PlusOne.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/15.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/plus-one/submissions/
/*
 给定一个由整数组成的非空数组所表示的非负整数，在该数的基础上加一。
 最高位数字存放在数组的首位， 数组中每个元素只存储单个数字。
 你可以假设除了整数 0 之外，这个整数不会以零开头。
 */
class E_066_PlusOne {
    /*
     1. 末位无进位，则末位加一即可，因为末位无进位，前面也不可能产生进位，比如 45 => 46
     2. 末位有进位，在中间位置进位停止，则需要找到进位的典型标志，即为当前位 %10 后为 0，
        则前一位加 1，直到不为 0 为止，比如 499 => 500
     3. 末位有进位，并且一直进位到最前方导致结果多出一位，对于这种情况，
        需要在第 2 种情况遍历结束的基础上，进行单独处理，比如 999 => 1000
     */
    class func plusOne(_ digits: [Int]) -> [Int] {
        var copyDigits = digits
        for index in (0..<copyDigits.count).reversed() {
            copyDigits[index] = copyDigits[index] + 1
            // 如果当前位与10取余，取余不为0，则说明没有进位，直接返回
            // 如果为 0，说明有进位，需要继续计算
            copyDigits[index] = copyDigits[index] % 10
            if copyDigits[index] != 0 {
                return copyDigits
            }
        }
        
        var overFlowDigits = [Int].init(repeating: 0, count: copyDigits.count+1)
        overFlowDigits[0] = 1
        return overFlowDigits
    }
}
