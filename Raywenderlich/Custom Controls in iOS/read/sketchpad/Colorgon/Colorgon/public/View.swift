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

@IBDesignable
public final class View: UIView {
    
  @IBInspectable
  public var selectionTouchRadiusCrossover: CGFloat = 50 {
    didSet {
      for gestureRecognizer in [
        tapGestureRecognizer,
        panGestureRecognizer
      ] as [GestureRecognizer] {
        gestureRecognizer.selectionTouchRadiusCrossover = selectionTouchRadiusCrossover
      }
    }
  }
  
  @IBInspectable
  public var valueSelectionRate: Float = -0.004
  
  /// 处理颜色选中事件
  public var handleColorSelection: ( (UIColor) -> Void )?
  
//MARK: fileprivate
    
  /// 选中的颜色，设置后，调用handle
  fileprivate var unitCubeColor = UnitCube.whiteColor {
    didSet {
      _handleColorSelection()
    }
  }
  
//MARK: Gesture Recognizers
  fileprivate private(set) lazy var tapGestureRecognizer: TapGestureRecognizer =
    self.makeGestureRecognizer( action: #selector(self.handleTap) )
  
  fileprivate private(set) lazy var panGestureRecognizer: PanGestureRecognizer =
    self.makeGestureRecognizer( action: #selector(self.handlePan) )
  
  private func makeGestureRecognizer<GestureRecognizer: UIGestureRecognizer>(
    action: Selector
  ) -> GestureRecognizer
  where GestureRecognizer: Colorgon.GestureRecognizer {
    let gestureRecognizer = GestureRecognizer(
      target: self,
      action: action
    )
    gestureRecognizer.selectionTouchRadiusCrossover = selectionTouchRadiusCrossover
    return gestureRecognizer
  }
  
//MARK: init
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initPhase2()
  }
  
  private func initPhase2() {
    [tapGestureRecognizer, panGestureRecognizer].forEach(addGestureRecognizer)
  }
}

//MARK: public
public extension View {
  @IBInspectable
  var value: Float {
    get {
      return colorgonLayer.value
    }
    set {
      colorgonLayer.value = newValue
      _handleColorSelection()
    }
  }
}

//MARK: fileprivate
private extension View {
  var colorgonLayer: Layer {
    return layer as! Layer
  }

  /// 私有方法，用于处理颜色选中
  func _handleColorSelection() {
    handleColorSelection?(
      UIColor(
        unitCubeColor: unitCubeColor,
        value: value
      )
    )
  }
  
//MARK: Gesture Recognizers
  @objc
  func handleTap() {
    handle(gestureRecognizer: tapGestureRecognizer)
  }
  
  @objc
  func handlePan() {
    handle(gestureRecognizer: panGestureRecognizer)
  }
  
  private func handle<GestureRecognizer: UIGestureRecognizer>(
    gestureRecognizer: GestureRecognizer
  ) where GestureRecognizer: Colorgon.GestureRecognizer {
    switch gestureRecognizer.state {
    case
    .began,
    .changed,
    .ended:
      switch gestureRecognizer.selection {
      case .color(let color):
        unitCubeColor = color
        
      case .valueDelta(let delta):
        self.value += delta * valueSelectionRate
      }
    default: break
    }
  }
}

//MARK: UIView
public extension View {
  override static var layerClass: AnyClass {
    return Layer.self
  }
  
    
  /// ib中的测试数据
  override func prepareForInterfaceBuilder() {
    colorgonLayer.setNeedsDisplay()
  }
}
