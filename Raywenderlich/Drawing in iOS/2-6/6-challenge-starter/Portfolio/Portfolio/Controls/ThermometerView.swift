///// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable
class ThermometerView: UIView {
  let thermoLayer = CAShapeLayer()
  let levelLayer = CAShapeLayer()
  let maskLayer = CAShapeLayer()

  var lineWidth: CGFloat {
    return bounds.width / 3
  }
  
  @IBInspectable var level: CGFloat = 0.5 {
    didSet {
      if level < 0.5 {
        thermoLayer.fillColor = UIColor.red.cgColor
      } else {
        thermoLayer.fillColor = UIColor.green.cgColor
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  private func setup() {
    layer.addSublayer(thermoLayer)
    layer.addSublayer(levelLayer)
    let width = bounds.width - lineWidth
    let height = bounds.height - lineWidth / 2
    let path = UIBezierPath(ovalIn: CGRect(x: 0, y: height-width, width: width, height: width))
    path.move(to: CGPoint(x: width / 2, y: height - width))
    path.addLine(to: CGPoint(x: width / 2, y: 10))
    thermoLayer.path = path.cgPath
    thermoLayer.strokeColor = UIColor.darkGray.cgColor
    thermoLayer.lineWidth = width / 3
    thermoLayer.position.x = lineWidth / 2
    thermoLayer.lineCap = kCALineCapRound
    
    maskLayer.path = thermoLayer.path
    maskLayer.lineWidth = thermoLayer.lineWidth
    maskLayer.lineCap = thermoLayer.lineCap
    maskLayer.position = thermoLayer.position
    maskLayer.strokeColor = thermoLayer.strokeColor
    maskLayer.lineWidth = thermoLayer.lineWidth - 6
    maskLayer.fillColor = nil
    
    buildLevelLayer()
    
    levelLayer.mask = maskLayer
    
    let pan = UIPanGestureRecognizer(target: self,
                                     action: #selector(handlePan(gesture:)))
    addGestureRecognizer(pan)
  }
  
  private func buildLevelLayer() {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: bounds.midX, y: bounds.height))
    path.addLine(to: CGPoint(x: bounds.midX, y: 0))
    levelLayer.strokeColor = UIColor.white.cgColor
    levelLayer.path = path.cgPath
    levelLayer.lineWidth = bounds.width
    levelLayer.strokeEnd = level
  }
  
  @objc func handlePan(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: gesture.view)
    let percent = translation.y / bounds.height
    
    level = max(0, min(1, levelLayer.strokeEnd - percent))
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    levelLayer.strokeEnd = level
    CATransaction.commit()
    
    gesture.setTranslation(.zero, in: gesture.view)
  }
}
























