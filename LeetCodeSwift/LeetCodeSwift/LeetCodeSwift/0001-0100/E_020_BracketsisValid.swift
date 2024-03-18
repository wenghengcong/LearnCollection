//
//  BracketsisValid.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/12.
//  Copyright © 2019 LuCi. All rights reserved.
//

import UIKit

struct Stack<Element> {
    fileprivate var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
}


/// 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
/// https://leetcode-cn.com/problems/valid-parentheses/
/*
 有效字符串需满足：
    * 左括号必须用相同类型的右括号闭合。
    * 左括号必须以正确的顺序闭合。
 */
class E_020_BracketsisValid {
    
    class func isValidEfficent(_ s: String) -> Bool {
        var stack = [Character]()
        for char in s {
            if char == "(" || char == "[" || char == "{" {
                stack.append(char)
            } else if char == ")" {
                guard stack.count != 0 && stack.removeLast() == "(" else {
                    return false
                }
            } else if char == "]" {
                guard stack.count != 0 && stack.removeLast() == "[" else {
                    return false
                }
            } else if char == "}" {
                guard stack.count != 0 && stack.removeLast() == "{" else {
                    return false
                }
            }
        }
        
        return stack.isEmpty
    }
    
    
    class func isValid(_ s: String) -> Bool {
        if s.count == 0 {
            return true
        }
        let charMap = ["{": "}","(": ")","[": "]"]
        var stack = Stack<Character>()
        for char in s {
            if char == ")" || char == "}" ||  char == "]" {
                if !stack.isEmpty() {
                    let top = String(stack.peek()!)
                    // 匹配到
                    if charMap[top] == String(char) {
                        _ = stack.pop()
                    } else { // 未匹配
                        return false
                    }
                } else {
                    return false
                }
            } else {
               stack.push(char)
            }
        }
        
        if stack.isEmpty() {
            return true
        }
        return false
    }
}
