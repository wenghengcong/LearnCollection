//
//  LongestCommonPrefix.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/9.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/// https://leetcode-cn.com/problems/longest-common-prefix/
/// 编写一个函数来查找字符串数组中的最长公共前缀。
class E_014_LongestCommonPrefix {
    
    /// 先将第一个字符串为最长公共前缀，然后判断后面每个字符串中是否符合
    /// 如果不包含，就将该公共前缀最后一位移除，继续判断，一直到出现公共前缀
    /// - Parameter strs: 字符串数组
    class func longestCommonPrefix(_ strs: [String]) -> String {
        guard strs.count > 0 else { return "" }
        var comPrefixs = strs[0]
                
        for i in 1..<strs.count {
            while !strs[i].hasPrefix(comPrefixs) {
                comPrefixs.removeLast()
                if comPrefixs == "" {
                    return ""
                }
            }
        }
        return comPrefixs
    }
}
