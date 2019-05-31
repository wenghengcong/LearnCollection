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

public final class RingLayer: CALayer {
  public var ringBackgroundColor = UIColor.darkGray.cgColor {
    didSet {
      backgroundLayer.strokeColor = ringBackgroundColor
    }
  }
  
  public var ringColor = UIColor.red.cgColor {
    didSet {
      gradientLayer.color = ringColor
      ringTipLayer.color = ringColor
    }
  }
  
  public var ringWidth: CGFloat = 40.0 {
    didSet {
      for layer in [
        backgroundLayer,
        foregroundMask
      ] {
          layer.lineWidth = ringWidth
      }
      
      ringTipLayer.ringWidth = ringWidth
      
      preparePaths()
    }
  }
  
  public var value: CGFloat = 0 {
    didSet {
      foregroundMask.path = getMaskPath(value: value)
      
        //将对应图层进行旋转多少度
      for layer: CALayer in [gradientLayer, ringTipLayer] {
        layer.setValue(
          getAngle(value: value),
          forKeyPath: CALayer.rotationKeyPath
        )
      }
    }
  }
  
//MARK: fileprivate
    // 图层层次：backgroundLayer -> foregroundLayer -> ringTipLayer
    // 其中foregroundLayer包含了gradientLayer，且其mask为foregroundMask
    // 进度圈背景圈层，在进度小于1时，设置该成颜色，可以通过ringBackgroundColor控制背景色
  fileprivate private(set) lazy var backgroundLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = self.ringBackgroundColor
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    return layer
  }()
  
    //进度圈图层
  fileprivate private(set) lazy var gradientLayer: CircularGradientLayer = {
    let layer = CircularGradientLayer()
    layer.color = self.ringColor
    return layer
  }()
  
    //进度圈前景的层，里面包含进度圈层
  fileprivate private(set) lazy var foregroundLayer: CALayer = {
    let layer = CALayer()
    layer.addSublayer(self.gradientLayer)
    layer.mask = self.foregroundMask
    return layer
  }()
  
    //foregroundLayer的蒙层，即foregroundLayer在foregroundMask区域内的才可见
  fileprivate private(set) lazy var foregroundMask: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.black.cgColor
    layer.fillColor = UIColor.clear.cgColor
    layer.lineWidth = self.ringWidth
    layer.lineCap = CAShapeLayerLineCap.round
    return layer
  }()
  
    //进度圈层最后部分的阴影区域
  fileprivate private(set) lazy var ringTipLayer: RingTipLayer = {
    let layer = RingTipLayer()
//    layer.ringWidth = self.ringWidth
//    layer.color = self.ringColor
    layer.ringWidth = self.ringWidth
    layer.color = UIColor.blue.cgColor
    return layer
  }()
  
//MARK: init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }

  public override init() {
    super.init()
    initPhase2()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    
    guard let layer = layer as? RingLayer
    else {return}
    
    ringWidth = layer.ringWidth
    value = layer.value
    ringBackgroundColor = layer.ringBackgroundColor
    ringColor = layer.ringColor
  }
  
  private func initPhase2() {
    backgroundColor = UIColor.black.cgColor
    [ backgroundLayer,
      foregroundLayer,
      ringTipLayer
    ].forEach(addSublayer)
    value = 0.8
  }
}

//MARK: CALayer
public extension RingLayer {
  override func layoutSublayers() {
    super.layoutSublayers()
    
    guard backgroundLayer.bounds != bounds
    else {return}
    
    for layer in [
      backgroundLayer,
      foregroundLayer,
      foregroundMask,
      gradientLayer,
      ringTipLayer
    ] {
      layer.bounds = bounds
      layer.position = center
    }
    
    preparePaths()
  }
}

//MARK: fileprivate
private extension RingLayer {
    // 圆的半径
  var radius: CGFloat {
    return ( min(bounds.width, bounds.height) - ringWidth ) / 2
  }
  
    // 获取value对应的角度，从0度角开始
  func getAngle(value: CGFloat) -> CGFloat {
    return value * 2 * .pi + angleOffsetForZero
  }

  func getMaskPath(value: CGFloat) -> CGPath {
    return makePath(
      startAngle: angleOffsetForZero,
      endAngle: getAngle(value: value)
    )
  }
  
  func preparePaths() {
    backgroundLayer.path = getMaskPath(value: 1)
    foregroundMask.path = getMaskPath(value: value)
  }
  
//MARK: private
    // 表示从顶部开始，否则从0开始，意味着从y轴0点的位置，相当于时钟3点
  private var angleOffsetForZero: CGFloat {
    return -.pi / 2
  }
  
    // 创建对应的贝塞尔曲线
    //
  private func makePath(
    startAngle: CGFloat = 0,
    endAngle: CGFloat
  ) -> CGPath {
    return UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true
    ).cgPath
  }
}
