//
//  MergeTowArray.swift
//  LeetCodeSwift
//
//  Created by 翁恒丛 on 2019/8/15.
//  Copyright © 2019 LuCi. All rights reserved.
//

import Foundation

/*
 给定两个有序整数数组 nums1 和 nums2，将 nums2 合并到 nums1 中，使得 num1 成为一个有序数组。
 说明:
    初始化 nums1 和 nums2 的元素数量分别为 m 和 n。
    你可以假设 nums1 有足够的空间（空间大小大于或等于 m + n）来保存 nums2 中的元素。
 https://leetcode-cn.com/problems/merge-sorted-array/
 */
class E_088_MergeTowArray {
    
    class func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var p1_index = m - 1
        var p2_index = n - 1
        var p_index = m + n - 1
        
        while p1_index >= 0 && p2_index >= 0 {
            if nums1[p1_index] < nums2[p2_index] {
                nums1[p_index] = nums2[p2_index]
                p2_index = p2_index - 1
            } else {
                nums1[p_index] = nums1[p1_index]
                p1_index = p1_index - 1
            }
            p_index = p_index - 1
        }
        
        while p2_index >= 0 {
            nums1[p_index] = nums2[p2_index]
            p2_index = p2_index - 1
            p_index = p_index - 1
        }
    }
}
