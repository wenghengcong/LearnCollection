//
//  E_383_CanConstruct.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/16.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation


/// https://github.com/youngyangyang04/leetcode-master/blob/master/problems/0383.%E8%B5%8E%E9%87%91%E4%BF%A1.md
/// https://leetcode.cn/problems/ransom-note/
/// 给你两个字符串：ransomNote 和 magazine ，判断 ransomNote 能不能由 magazine 里面的字符构成。
/// 如果可以，返回 true ；否则返回 false 。
/// magazine 中的每个字符只能在 ransomNote 中使用一次。
class E_383_CanConstruct {
    func canConstruct(_ ransomNote: String, _ magazine: String) -> Bool {
        var res = false
        
        var mapper:[Character: Int] = [:]
        for char in magazine {
            mapper[char, default: 0] += 1
        }
        
        return res
    }
}
