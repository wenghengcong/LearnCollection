//
//  RomanToInt.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/9.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/roman-to-integer/
/// 罗马数字转整数
class E_013_RomanToInt {
    
    /*
     题目说明
    字符          数值
    I             1
    V             5
    X             10
    L             50
    C             100
    D             500
    M             1000

    通常情况下，罗马数字中小的数字在大的数字的右边。但也存在特例，例如 4 不写做 IIII，而是 IV。数字 1 在数字 5 的左边，所表示的数等于大数 5 减小数 1 得到的数值 4 。同样地，数字 9 表示为 IX。这个特殊的规则只适用于以下六种情况：

    I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。
    X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。
    C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。
    */
    
    
    class func romanToIntEffecient(_ s: String) -> Int {
        let romanIntDic:[Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        ]
        var res = 0
        var tmp = 0
        for c in s {
            let num = romanIntDic[c]!
            if tmp == 0 || num <= tmp {
                // 假如左边的比右边大
                res+=num
            } else {
                // 出现IV等情况，即上一个访问的字符比当前的字符小
                // 此时，需要加上num，并且减去2倍的上一个字符
                //（因为上一次访问加了，还有一个是此次两个字符需要合并要减去一个，共减去两个）
                res = res+num-2*tmp
            }
            tmp = num
        }
        return res
    }
    
    /// 语法：类型方法：class在func前面加class
    /// 结构体或者枚举在前面加static
    /// - Parameter s: 罗马字符串
    class func romanToInt(_ s: String) -> Int {
        let romanIntDic: [Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000,
        ]
        let startIndex = s.startIndex
        var lastChar = s[startIndex]
        var result: Int = (romanIntDic[lastChar] ?? 0)

        var moveStep = 1
        while moveStep < s.count {
            let nowIndex = s.index(startIndex, offsetBy: moveStep)
            let nowChar = s[nowIndex]
            if ( lastChar == "I" && (nowChar == "V" || nowChar == "X") )
            || ( lastChar == "X" && (nowChar == "L" || nowChar == "C") )
            || ( lastChar == "C" && (nowChar == "D" || nowChar == "M") ) {
                result = result - (romanIntDic[lastChar] ?? 0)
                let minusTwo = (romanIntDic[nowChar] ?? 0) - (romanIntDic[lastChar] ?? 0)
                result = result + minusTwo
            } else {
                result = result + (romanIntDic[nowChar] ?? 0)
            }
            // 继续迭代
            moveStep = moveStep + 1
            lastChar = nowChar
        }
        
        return result
    }
}
