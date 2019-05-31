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


import UIKit

final class PanGestureRecognizer: UIPanGestureRecognizer, GestureRecognizer {
    // 上一次Y的位置
  fileprivate var lastYPositionInView: CGFloat?
  
//MARK: GestureRecognizer
  var selection = Selection.color(UnitCube.whiteColor)
  var selectionTouchRadiusCrossover = CGFloat()

//MARK: init
  override init(
    target: Any?,
    action: Selector?
  ) {
    super.init(
      target: target,
      action: action
    )
    
    maximumNumberOfTouches = 1
  }
}

//MARK: GestureRecognizer
extension PanGestureRecognizer {
  func handleLargeRadiusTouch(yPositionInView: CGFloat) {
    // 延迟调用，在return之前会调用
    defer {
      lastYPositionInView = yPositionInView
    }
    guard let lastYPositionInView = lastYPositionInView
    else {return}
    
    selection = .valueDelta(
      Float(yPositionInView - lastYPositionInView)
    )
  }
}

//MARK: UIGestureRecognizer
extension PanGestureRecognizer {
  override func touchesMoved(
    _ touches: Set<UITouch>,
    with event: UIEvent
  ) {
    setSelection(touches: touches)
    super.touchesMoved(touches, with: event)
  }
  
  override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent
  ) {
    lastYPositionInView = nil
    super.touchesEnded(touches, with: event)
  }
  
  override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent
  ) {
    lastYPositionInView = nil
    super.touchesCancelled(touches, with: event)
  }
}
