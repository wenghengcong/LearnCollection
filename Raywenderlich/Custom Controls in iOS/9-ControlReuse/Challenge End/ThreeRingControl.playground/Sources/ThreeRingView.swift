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

public final class ThreeRingView: UIView {
//MARK: public
  public var animationDuration = 1.5
  
  public var ringWidth: CGFloat = 20 {
    didSet {
      drawLayers()
      for ringLayer in ringLayers.values {
        ringLayer.ringWidth = ringWidth
      }
    }
  }
  
  public var ringPadding: CGFloat = 1 {
    didSet {
      drawLayers()
    }
  }
  
  public var ringBackgroundColor = UIColor.darkGray {
    didSet {
      for ringLayer in ringLayers.values {
        ringLayer.ringBackgroundColor = ringBackgroundColor.cgColor
      }
    }
  }
  
//MARK: fileprivate
  fileprivate let ringLayers: [Ring: RingLayer] = [
    .inner: RingLayer(),
    .middle: RingLayer(),
    .outer: RingLayer()
  ]
  
//MARK: init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initPhase2()
  }
  
  private func initPhase2() {
    backgroundColor = UIColor.black
    for ringLayer in ringLayers.values {
      layer.addSublayer(ringLayer)
      ringLayer.backgroundColor = UIColor.clear.cgColor
      ringLayer.ringBackgroundColor = ringBackgroundColor.cgColor
      ringLayer.ringWidth = ringWidth
      ringLayer.value = 0
    }
    
    innerRingColor = UIColor(cgColor: Color.pink)
    middleRingColor = UIColor(cgColor: Color.blue)
    outerRingColor = UIColor(cgColor: Color.green)
  }
}

//MARK: public
public extension ThreeRingView {
  var innerRingValue: CGFloat {
    get {
      return ringLayers[.inner]!.value
    }
    set {
      ringLayers[.inner]!.value = newValue
    }
  }
  
  var middleRingValue: CGFloat {
    get {
      return ringLayers[.middle]!.value
    }
    set {
      ringLayers[.middle]!.value = newValue
    }
  }
  
  var outerRingValue: CGFloat {
    get {
      return ringLayers[.outer]!.value
    }
    set {
      ringLayers[.outer]!.value = newValue
    }
  }
  
  var innerRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.inner]!.ringColor)
    }
    set {
      ringLayers[.inner]!.ringColor = newValue.cgColor
    }
  }
  
  var middleRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.middle]!.ringColor)
    }
    set {
      ringLayers[.middle]!.ringColor = newValue.cgColor
    }
  }
  
  var outerRingColor: UIColor {
    get {
      return UIColor(cgColor: ringLayers[.outer]!.ringColor)
    }
    set {
      ringLayers[.outer]!.ringColor = newValue.cgColor
    }
  }
  
  func animate(
    ring: Ring,
    value: CGFloat
  ) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationDuration)
    defer {
      CATransaction.commit()
    }
    
    ringLayers[ring]!.animate(value: value)
  }
}

//MARK: private
private extension ThreeRingView {
  func drawLayers() {
    // the largest a ring can be,
    // and still fit withing the bounds of the current view
    let maxSize = min(bounds.width, bounds.height)
    
    // measured between adjacent rings
    let sizeDifference = (ringWidth + ringPadding) * 2
    
    for (index, ringLayer) in ringLayers {
      let size = maxSize - sizeDifference * CGFloat(2 - index.rawValue)
      ringLayer.bounds = CGRect(
        x: 0,
        y: 0,
        width: size,
        height: size
      )
      
      ringLayer.position = layer.position
    }
  }
}

//MARK: UIView
public extension ThreeRingView {
  override func layoutSubviews() {
    super.layoutSubviews()
    drawLayers()
  }
}
