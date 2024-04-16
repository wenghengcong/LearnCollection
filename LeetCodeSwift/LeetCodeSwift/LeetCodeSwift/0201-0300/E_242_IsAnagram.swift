//
//  IsAnagram.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/20.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode.cn/problems/valid-anagram/description/
/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0242.%E6%9C%89%E6%95%88%E7%9A%84%E5%AD%97%E6%AF%8D%E5%BC%82%E4%BD%8D%E8%AF%8D.md
/// 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
class E_242_IsAnagram {
    /// 哈希表
    class func isAnagram(_ s: String, _ t: String) -> Bool {
        if s.count != t.count {
            return false
        }
        var count: [Int] = [Int].init(repeating: 0, count: 128)
        for cha: Character in s {
            // 如果说cha不是ascii值
            if let chaAsciiValue = cha.asciiValue {
                let key = Int(chaAsciiValue)
                count[key] = count[key] + 1
            }
        }
        
        for cha: Character in t {
            if let chaAsciiValue = cha.asciiValue {
                let key = Int(chaAsciiValue)
                count[key] = count[key] - 1
                if count[key] < 0 {
                    return false
                }
            }
        }
        return true
    }

    /// 优化isAnagram，将对应的字母放在26个空间中
    class func isAnagram2(_ s: String, _ t: String) -> Bool {
        if s.count != t.count {
               return false
        }
        var count: [Int] = [Int].init(repeating: 0, count: 128)
        for cha: Character in s {
            // 如果说cha不是ascii值
            if let chaAsciiValue = cha.asciiValue {
                let key = Int(chaAsciiValue-Character("a").asciiValue!)
                count[key] = count[key] + 1
            }
        }

        for cha: Character in t {
            if let chaAsciiValue = cha.asciiValue {
                let key = Int(chaAsciiValue-Character("a").asciiValue!)
                count[key] = count[key] - 1
                if count[key] < 0 {
                    return false
                }
            }
        }
        return true
    }

    /// 该方法会超时：O(n2)
    class func isAnagramBad(_ s: String, _ t: String) -> Bool {
        if s.count != t.count {
            return false
        }
        var tCopy = t
        for characte in s {
            //contains 复杂度为O(n)
            if tCopy.contains(characte) {
                let index = tCopy.firstIndex(of: characte)!
                tCopy.remove(at: index)
            } else {
                return false
            }
        }
        return tCopy.isEmpty
    }
}
