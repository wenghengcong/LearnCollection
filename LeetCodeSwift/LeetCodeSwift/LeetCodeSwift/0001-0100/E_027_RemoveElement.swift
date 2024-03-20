//
//  E_027_RemoveElement.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/3/18.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation

class E_027_RemoveElement {
    
    class func removeElement_01(_ nums: inout [Int], _ val: Int) -> Int {
        var size = nums.count
        var i = 0 // 定义变量i，并初始化为0
        while i < size { // 当i小于数组长度时执行循环
            if nums[i] == val { // 如果数组中第i个元素等于给定的整数val
                for j in (i + 1)..<size { // 遍历从i+1到数组末尾的范围
                    nums[j - 1] = nums[j] // 将数组中j位置的元素赋值给j-1位置的元素，相当于删除了第i个元素
                }
                size -= 1 // 更新数组的长度，相当于删除了一个元素
                i -= 1 // 因为删除了一个元素，所以需要将i减1，以保证不漏掉任何一个元素
            }
            i += 1 // 更新i，继续下一个元素的判断
        }
        return size // 返回最终的数组长度
    }
    
    /*
     快慢指针
     快指针：寻找新数组的元素 ，新数组就是不含有目标元素的数组
     慢指针：用于记录移除元素后的数组索引
     inout 表示可以变更
     时间复杂度：O(n)
     空间复杂度：O(1)
     */
    class func removeElement_02(_ nums: inout [Int], _ val: Int) -> Int {
        var slowIndex = 0
        for fastIndex in 0..<nums.count {
            if(val != nums[fastIndex]) {
                // 在循环中，检查当前元素是否等于给定的值 val，
                // 如果不等于，则将当前元素赋值给 slowIndex 所指向的位置，
                // 并将 slowIndex 加一。这样就相当于将不等于给定值的元素移到了数组的前面
                nums[slowIndex] = nums[fastIndex]
                slowIndex += 1
            }
        }
        return slowIndex
    }
    
    /*
     * 相向双指针方法，基于元素顺序可以改变的题目描述改变了元素相对位置，确保了移动最少元素
     * 时间复杂度：O(n)
     * 空间复杂度：O(1)
     */
    class func removeElement_03(_ nums: inout [Int], _ val: Int) -> Int {
        var leftIndex = 0 // 定义左边界索引
        var rightIndex = nums.count - 1 // 定义右边界索引
        while leftIndex <= rightIndex { // 循环直到左边界索引小于等于右边界索引
            // 找左边等于 val 的元素
            while leftIndex <= rightIndex && nums[leftIndex] != val { // 找到第一个左边等于 val 的元素位置
                leftIndex += 1 // 左边界索引向右移动
            }
            // 找右边不等于 val 的元素
            while leftIndex <= rightIndex && nums[rightIndex] == val { // 找到第一个右边不等于 val 的元素位置
                rightIndex -= 1 // 右边界索引向左移动
            }
            // 将右边不等于 val 的元素覆盖左边等于 val 的元素
            if leftIndex < rightIndex { // 如果左边界索引小于右边界索引
                nums[leftIndex] = nums[rightIndex] // 将右边不等于 val 的元素覆盖左边等于 val 的元素
                leftIndex += 1 // 左边界索引向右移动
                rightIndex -= 1 // 右边界索引向左移动
            }
        }
        return leftIndex // 返回左边界索引，即移除元素后的数组长度
    }
}
