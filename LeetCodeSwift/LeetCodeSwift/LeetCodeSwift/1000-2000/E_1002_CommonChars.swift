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
    class func commonChars(_ words: [String]) -> [String] {
        if words.isEmpty {
            return []
        }
        
        let size = words.count
        // 遍历整个数组，将其存在【char: 数目】的字典中
        var allWordsMappers: [[String: Int]] = []
        for word in words {
            var chars:[String: Int] = [:]
            for char in word {
                // 在每个word里寻找各个字符出现，word中不管出现几次，一个word只+1次出现的char
                let key = String(char)
                if let hasKey = chars[key] {
                    chars[key] = hasKey + 1
                } else {
                    chars[key] = 1
                }
            }
            allWordsMappers.append(chars)
        }

        var commonChars: [String: Int] = [:]
        for mapper in allWordsMappers {
            for (key,value) in mapper.reversed() {
                commonChars[key] = min(commonChars[key], value)
            }
        }
        return words
    }
}
