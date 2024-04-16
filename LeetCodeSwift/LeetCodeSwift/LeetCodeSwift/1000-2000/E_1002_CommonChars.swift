//
//  E_1002_CommonChars.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/14.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation


/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/1002.%E6%9F%A5%E6%89%BE%E5%B8%B8%E7%94%A8%E5%AD%97%E7%AC%A6.md
/// https://leetcode.cn/problems/find-common-characters/
/// 给你一个字符串数组 words ，请你找出所有在 words 的每个字符串中都出现的共用字符（ 包括重复字符），并以数组形式返回。你可以按 任意顺序 返回答案。
/// 输入：words = ["bella","label","roller"]
/// 输出：["e","l","l"]
class E_1002_CommonChars {
    
    /// 主要思路：将每个字符串中出现的字母放在哈希表中（重复的字母数字累加即可）
    /// 每次新的哈希表将与之前的哈希表的每一位进行min取值，保证不超出当前出现的次数
    class func commonChars(_ words: [String]) -> [String] {
        var res = [String]()
        if words.isEmpty {
            return res
        }
        
        /// 在Swift中，Unicode scalar 是Unicode标量的一种表示形式。
        /// Unicode标量是Unicode字符集中的单个字符，它们由一个唯一的标量值表示。
        /// 这个标量值可以是一个十六进制数字，例如U+0041代表拉丁字母"A"。
        /// Unicode scalar 是这些标量值的数值表示，Swift中用UInt32类型表示。
        let aUnicodeScalarValue = "a".unicodeScalars.first!.value
        let maxCount = 26
        // 用于统计所有字符串每个字母出现的 最小频率
        var hash = Array(repeating: 0, count: maxCount)
        // 统计第一个字符串每个字母出现的次数
        for unicodeScalar in words.first!.unicodeScalars {
            hash[Int(unicodeScalar.value - aUnicodeScalarValue)] += 1
        }
        
        // 统计除第一个字符串每个字母出现的次数
        for idx in 1 ..< words.count {
            var hashOtherStr = Array(repeating: 0, count: maxCount)
            for unicodeScalar in words[idx].unicodeScalars {
                hashOtherStr[Int(unicodeScalar.value - aUnicodeScalarValue)] += 1
            }
            // 更新hash,保证hash里统计的字母为出现的最小频率
            for k in 0 ..< maxCount {
                hash[k] = min(hash[k], hashOtherStr[k])
            }
        }
        // 将hash统计的字符次数，转成输出形式
        for i in 0 ..< maxCount {
            while hash[i] != 0 { // 注意这里是while，多个重复的字符
                let currentUnicodeScalarValue: UInt32 = UInt32(i) + aUnicodeScalarValue
                let currentUnicodeScalar: UnicodeScalar = UnicodeScalar(currentUnicodeScalarValue)!
                let outputStr = String(currentUnicodeScalar) // UnicodeScalar -> String
                res.append(outputStr)
                hash[i] -= 1
            }
        }
        return res
    }
}
