//
//  E_202_HappyNumber.swift
//  LeetCodeSwift
//
//  Created by Hunt on 2019/8/26.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation


/// https://leetcode-cn.com/problems/happy-number/
/// 一个“快乐数”定义为：对于一个正整数，每一次将该数替换为它每个位置上的数字的平方和，
/// 然后重复这个过程直到这个数变为 1，也可能是无限循环但始终变不到 1。
/// 如果可以变为 1，那么这个数就是快乐数。
class E_202_HappyNumber {
    
    
    /// 将每次计算的元素放进集合，如果有循环就能判断出来
    /// - Parameter n: <#n description#>
    class func isHappy(_ n: Int) -> Bool {
        var set: Set<Int> = []
        var current = n
        while true {
            current = calSum(current)
            if set.contains(current) {
                return false
            } else {
                if current == 1 {
                    return true
                }
                set.insert(current)
            }
        }
    }
    
   class func calSum(_ n: Int) -> Int {
        var sum = 0
        var nC = n
        while nC > 0 {
            let lastNum = nC % 10
            sum += lastNum * lastNum
            nC = nC / 10
        }
        return sum
    }
    
    /*
     方法：使用“快慢指针”思想找出循环：“快指针”每次走两步，“慢指针”每次走一步，
     当二者相等时，即为一个循环周期。此时，判断是不是因为1引起的循环，是的话就是快乐数，否则不是快乐数。
     注意：此题不建议用集合记录每次的计算结果来判断是否进入循环，因为这个集合可能大到无法存储；
     另外，也不建议使用递归，同理，如果递归层次较深，会直接导致调用栈崩溃。
     不要因为这个题目给出的整数是int型而投机取巧。
     */
}
