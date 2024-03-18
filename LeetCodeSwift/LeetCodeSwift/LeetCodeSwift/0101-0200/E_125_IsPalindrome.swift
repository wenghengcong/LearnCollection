//
//  IsPalindrome.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/23.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/valid-palindrome/submissions/

/// 给定一个字符串，验证它是否是回文串，只考虑字母和数字字符，可以忽略字母的大小写。
/// 说明：本题中，我们将空字符串定义为有效的回文串。
class E_125_IsPalindrome {

    /// - Parameter s: <#s description#>
    class func isPalindrome(_ s: String) -> Bool {
        let sChars = Array(s.lowercased())
        var tail = s.count-1
        var head = 0
        while head <= tail {
            while !sChars[head].isLetterOrNumber && head < tail {
                head += 1
            }
            
            while !sChars[tail].isLetterOrNumber && head < tail {
                tail -= 1
            }
            
            if sChars[head] != sChars[tail] {
                return false
            }
            head += 1
            tail -= 1
        }
        
        return true
    }
}

extension Character {
    var isLetterOrNumber: Bool {
        return isLetter || isNumber
    }
}
