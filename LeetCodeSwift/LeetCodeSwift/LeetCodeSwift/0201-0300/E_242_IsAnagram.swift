//
//  IsAnagram.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/20.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/valid-anagram/submissions/
/// 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
class E_242_IsAnagram {
    /// 哈希表
    class func isAnagram(_ s: String, _ t: String) -> Bool {
        if s.count != t.count {
               return false
        }
        var count: [Int] = [Int].init(repeating: 0, count: 128)
        for cha: Character in s {
            let key = Int(cha.asciiValue!)
            count[key] = count[key] + 1
        }
        
        for cha: Character in t {
            let key = Int(cha.asciiValue!)
            count[key] = count[key] - 1
            if count[key] < 0 {
                return false
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
