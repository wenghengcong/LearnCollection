/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import simd
import UIKit.UIGestureRecognizerSubclass

protocol GestureRecognizer: class {
  var selection: Selection {get set}
    
  /// 触摸选中交叉点的半径
    // 小于该半径，直接后去颜色
    // 否则处理更大的触摸半径
  var selectionTouchRadiusCrossover: CGFloat {get set}
  
   /// 否则处理更大的触摸半径
  func handleLargeRadiusTouch(yPositionInView: CGFloat)
}

extension GestureRecognizer where Self: UIGestureRecognizer {
    
  /// 获取Touch对应的位置，从位置信息中提取出颜色值
  func setSelection(touches: Set<UITouch>) {
    guard let touch = touches.first
    else {return}
    
    let positionInView = touch.location(in: view)
    // 获取触摸半径
    if touch.majorRadius < selectionTouchRadiusCrossover {
      selection = .color(
        UnitCube.getColor(
          positionInView: positionInView,
          viewSize: view!.bounds.size
        )
      )
    } else {
      handleLargeRadiusTouch(yPositionInView: positionInView.y)
    }
  }
}

//MARK:
enum Selection {
  case
    color(float3),
    valueDelta(Float)
}
