//
//  E_059_GenerateMatrix.swift
//  LeetCodeSwift
//
//  Created by Nemo on 2024/3/20.
//  Copyright © 2024 LuCi. All rights reserved.
//

import Foundation
/// https://leetcode.cn/problems/spiral-matrix-ii/
class E_059_GenerateMatrix {
    class func generateMatrix(_ n: Int) -> [[Int]] {
        // 初始化一个 n × n 的二维数组，元素初始值都为 0
        var result = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
        
        var startRow = 0 // 螺旋矩阵起始行索引
        var startColumn = 0 // 螺旋矩阵起始列索引
        var loopCount = n / 2 // 计算需要循环的次数，每一圈循环需要处理四条边，因此除以2
        let mid = n / 2 // 矩阵的中间位置（用于处理奇数行列数情况）
        var count = 1 // 用于赋值给矩阵中每个格子的数值，从1开始递增
        var offset = 1 // 控制每一圈循环时边界的收缩量，每次循环收缩2（因为左右两侧都要收缩）
        var row: Int // 当前遍历的行索引
        var column: Int // 当前遍历的列索引
        
        // 开始循环生成螺旋矩阵
        while loopCount > 0 {
            row = startRow
            column = startColumn
            
            // 从左到右填充矩阵的上边界
            for c in column ..< startColumn + n - offset {
                result[startRow][c] = count
                count += 1
                column += 1
            }
            
            // 从上到下填充矩阵的右边界
            for r in row ..< startRow + n - offset {
                result[r][column] = count
                count += 1
                row += 1
            }
            
            // 从右到左填充矩阵的下边界
            for _ in startColumn ..< column {
                result[row][column] = count
                count += 1
                column -= 1
            }
            
            // 从下到上填充矩阵的左边界
            for _ in startRow ..< row {
                result[row][column] = count
                count += 1
                row -= 1
            }
            
            // 更新起始行列索引和边界收缩量
            startRow += 1
            startColumn += 1
            offset += 2
            loopCount -= 1
        }
        
        // 如果矩阵维度为奇数，需额外赋值中间位置的数值
        if (n % 2) != 0 {
            result[mid][mid] = count
        }
        
        // 返回生成的螺旋矩阵
        return result
    }
    
}
