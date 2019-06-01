/*
* Copyright (c) 2015 Razeware LLC
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
class StatView: UIView {
  
  let percentLabel = UILabel()
  let captionLabel = UILabel()
  
  var range: CGFloat = 10
  var curValue: CGFloat = 0 {
    didSet {
      animate()
    }
  }
  let margin: CGFloat = 10
  
  let bgLayer = CAShapeLayer()
  @IBInspectable var bgColor: UIColor = UIColor.gray {
    didSet {
      configure()
    }
  }
    
  let fgLayer = CAShapeLayer()
  @IBInspectable var fgColor: UIColor = UIColor.black {
    didSet {
      configure()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    configure()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
    configure()
  }
  
  func setup() {
    
    // Setup background layer
    bgLayer.lineWidth = 20.0
    bgLayer.fillColor = UIColor.red.cgColor
    bgLayer.strokeEnd = 1
    layer.addSublayer(bgLayer)
    // 进度圈
    fgLayer.lineWidth = 20.0
    fgLayer.fillColor = nil
    fgLayer.strokeEnd = 0
    layer.addSublayer(fgLayer)
    
    // Setup percent label
    percentLabel.font = UIFont.systemFont(ofSize: 26)
    percentLabel.textColor = UIColor.white
    percentLabel.text = "0/0"
    percentLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(percentLabel)
    
    // Setup caption label
    captionLabel.font = UIFont.systemFont(ofSize: 26)
    captionLabel.text = "Chapters Read"
    captionLabel.textColor = UIColor.white
    captionLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(captionLabel)
    
    // Setup constraints
    let percentLabelCenterX = percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    let percentLabelCenterY = percentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -margin)
    NSLayoutConstraint.activate([percentLabelCenterX, percentLabelCenterY])
    
    let captionLabelCenterX = captionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -margin)
    let captionLabelBottom = captionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin)
    NSLayoutConstraint.activate([captionLabelCenterX, captionLabelBottom])
  }
  
  func configure() {
    bgLayer.strokeColor = bgColor.cgColor
    fgLayer.strokeColor = fgColor.cgColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupShapeLayer(shapeLayer: bgLayer)
    setupShapeLayer(shapeLayer: fgLayer)
  }
  
  private func setupShapeLayer(shapeLayer:CAShapeLayer) {
    shapeLayer.frame = self.bounds
    let startAngle = DegreesToRadians(value: 135.0)
    let endAngle = DegreesToRadians(value: 45.0)
    let center = percentLabel.center
    let radius = (self.bounds.height) * 0.35
    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    shapeLayer.path = path.cgPath
    
  }
  
    
  /// 动画
  private func animate() {
    percentLabel.text = String(format: "%.0f/%.0f", curValue, range)

    var fromValue = fgLayer.strokeEnd
    let toValue = curValue / range
    if let presentationLayer = fgLayer.presentation() {
      fromValue = presentationLayer.strokeEnd
    }
    let percentChange = abs(fromValue - toValue)
    
    // 1
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = fromValue
    animation.toValue = toValue
    
    // 2
    animation.duration = CFTimeInterval(percentChange * 4)
    
    // 3
    fgLayer.removeAnimation(forKey: "stroke")
    fgLayer.add(animation, forKey: "stroke")
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    fgLayer.strokeEnd = toValue
    CATransaction.commit()
  }
  
}
