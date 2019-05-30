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

final class RingTipLayer: CALayer {
//MARK: internal
  var color = UIColor.red.cgColor {
    didSet {
      tipLayer.strokeColor = color
    }
  }
  
  var ringWidth: CGFloat = 40 {
    didSet {
      processLayers{$0.lineWidth = ringWidth}
      preparePaths()
    }
  }
  
//MARK: fileprivate
  fileprivate let shadowMaskLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.black.cgColor
    layer.lineCap = kCALineCapButt
    return layer
  }()
  
  fileprivate private(set) lazy var tipLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.lineWidth = self.ringWidth
    return layer
  }()
  
  fileprivate private(set) lazy var shadowLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.lineCap = kCALineCapRound
    layer.shadowColor = UIColor.black.cgColor
    layer.strokeColor = UIColor.black.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = 12
    layer.shadowOpacity = 1
    layer.mask = self.shadowMaskLayer
    return layer
  }()
  
//MARK: init
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  override init() {
    super.init()
    initPhase2()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    
    guard let layer = layer as? RingTipLayer
    else {return}
    
    color = layer.color
    ringWidth = layer.ringWidth
  }
  
  private func initPhase2() {
    [shadowLayer, tipLayer].forEach(addSublayer)
    preparePaths()
  }
}

//MARK: fileprivate
private extension RingTipLayer {
  func processLayers(process: (CAShapeLayer) -> Void) {
    [ tipLayer,
      shadowLayer,
      shadowMaskLayer
    ].forEach(process)
  }
  
  func preparePaths() {
    func makePath(
      startAngle: CGFloat = 0,
      endAngle: CGFloat
    ) -> CGPath {
      return UIBezierPath(
        arcCenter: center,
        radius: ( min(bounds.width, bounds.height) - ringWidth ) / 2,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: true
      ).cgPath
    }
    
    let shadowMaskPath = makePath(endAngle: .pi / 2)
    shadowMaskLayer.path = shadowMaskPath
    
    for layer in [shadowLayer, tipLayer] {
      layer.path = makePath(
        startAngle: -0.01,
        endAngle: 0
      )
    }
  }
}

//MARK: CALayer
extension RingTipLayer {
  override func layoutSublayers() {
    processLayers{
      $0.bounds = bounds
      $0.position = center
    }
    preparePaths()
  }
}
