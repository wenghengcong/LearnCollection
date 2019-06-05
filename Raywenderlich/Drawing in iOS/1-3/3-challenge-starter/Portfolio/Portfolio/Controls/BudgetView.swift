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
class BudgetView: UIView {
  
  let label = UILabel()
  
  // stepper is 0 to 10
  let stepper = UIStepper()
  
  let step: Double = 100  // go up by $100 at a time
  let maxValue:Double = 4
  
  
  var currentValue: Double = 0 {
    didSet {
      label.text = "\(Int(currentValue * step))"
      foregroundLayer.strokeEnd = CGFloat(currentValue/maxValue)
    }
  }
  
  var backgroundLayer = CAShapeLayer()
  var foregroundLayer = CAShapeLayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  func setup() {
    buildInterface()
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(foregroundLayer)
    foregroundLayer.strokeEnd = 0
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    buildLayer(layer: backgroundLayer)
    backgroundLayer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor
    
    buildLayer(layer: foregroundLayer)
    foregroundLayer.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
  }
  
  func buildLayer(layer: CAShapeLayer) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: bounds.height/3))
    path.addLine(to: CGPoint(x: bounds.width, y: bounds.height/3))
    layer.path = path.cgPath
    layer.lineWidth = 20
    layer.fillColor = nil
    layer.lineCap = kCALineCapRound
  }
  
  
  // MARK:- Subviews
  
  @objc func handleStepper(_ stepper: UIStepper) {
    currentValue = stepper.value
  }
  
  func buildInterface() {
    stepper.minimumValue = 0
    stepper.maximumValue = maxValue
    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.addTarget(self, action: #selector(handleStepper(_:)), for: .valueChanged)
    stepper.isContinuous = true
    
    addSubview(stepper)
    let stepCenterX = stepper.centerXAnchor.constraint(equalTo: centerXAnchor)
    let stepBottom = stepper.bottomAnchor.constraint(equalTo: bottomAnchor)
    NSLayoutConstraint.activate([stepCenterX, stepBottom])
    
    label.text = "0"
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(label)
    let labelCenterX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
    let labelCenterY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
    NSLayoutConstraint.activate([labelCenterX, labelCenterY])
  }
  
}


