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
      for layer in [backgroundLayer, foregroundMask] {
        layer.lineWidth = ringWidth
      }
      
      ringTipLayer.ringWidth = ringWidth
      
      preparePaths()
    }
  }
  
  public var value: CGFloat {
    get {
      return _value
    }
    set {
      _value = newValue
      
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      defer {
        CATransaction.commit()
      }
      
      foregroundMask.path = getMaskPath(value: value)
      
      for layer: CALayer in [gradientLayer, ringTipLayer] {
        layer.setValue(
          getAngle(value: value),
          forKeyPath: CALayer.rotationKeyPath
        )
      }
    }
  }
  
//MARK: fileprivate
  fileprivate private(set) lazy var backgroundLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = self.ringBackgroundColor
    layer.lineWidth = self.ringWidth
    layer.fillColor = nil
    return layer
  }()
  
  fileprivate private(set) lazy var gradientLayer: CircularGradientLayer = {
    let layer = CircularGradientLayer()
    layer.color = self.ringColor
    return layer
  }()
  
  fileprivate private(set) lazy var foregroundLayer: CALayer = {
    let layer = CALayer()
    layer.addSublayer(self.gradientLayer)
    layer.mask = self.foregroundMask
    return layer
  }()
  
  fileprivate private(set) lazy var foregroundMask: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.black.cgColor
    layer.fillColor = UIColor.clear.cgColor
    layer.lineWidth = self.ringWidth
    layer.lineCap = kCALineCapRound
    return layer
  }()
  
  fileprivate private(set) lazy var ringTipLayer: RingTipLayer = {
    let layer = RingTipLayer()
    layer.ringWidth = self.ringWidth
    layer.color = self.ringColor
    return layer
  }()
  
  fileprivate var _value: CGFloat = 0
  
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

//MARK: internal
extension RingLayer {
  func animate(value: CGFloat) {
    guard case let angleDelta = (value - self.value) * 2 * .pi,
      abs(angleDelta) > 0.001
    else {return}
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    CATransaction.setAnimationTimingFunction(
      CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    )
    defer {
      CATransaction.commit()
    }
    
    for layer in [ringTipLayer, gradientLayer] {
      layer.add(
        CAKeyframeAnimation(
          layer: layer,
          rotationAngle: angleDelta
        ),
        forKey: CALayer.rotationKeyPath
      )
    }

    _value = value
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
  var radius: CGFloat {
    return ( min(bounds.width, bounds.height) - ringWidth ) / 2
  }
  
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
  private var angleOffsetForZero: CGFloat {
    return -.pi / 2
  }
  
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
