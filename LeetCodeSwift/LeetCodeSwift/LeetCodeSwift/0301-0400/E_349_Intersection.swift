//
//  E_349_Intersection.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/4/16.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

class E_349_Intersection {
    
    func intersection(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var res:[Int] = []
        guard !nums1.isEmpty && !nums2.isEmpty else {
            return res
        }
        
        var numDic:[Int: Int] = [:]
        for num in nums1 {
            if numDic.keys.contains(num) {
                numDic[num]! += 1
            } else {
                numDic[num] = 1
            }
        }
        
        for num in nums2 {
            if numDic.keys.contains(num) && !res.contains(num) {
                res.append(num)
            }
        }
        
        return res
    }
    
    func intersection_2(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var res:[Int] = []
        guard !nums1.isEmpty && !nums2.isEmpty else {
            return res
        }
        var set1 = Set<Int>()
        var set2 = Set<Int>()
        for num in nums1 {
            set1.insert(num)
        }
        for num in nums2 {
            if set1.contains(num) {
                set2.insert(num)
            }
        }
        res = Array(set2)
        
        return res
    }
    
}
