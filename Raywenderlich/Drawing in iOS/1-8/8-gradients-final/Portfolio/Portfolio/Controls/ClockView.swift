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
class ClockView: UIView {
  
  var dial = CAShapeLayer()
  var pointer = CAShapeLayer()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }

  private func setup() {
    layer.addSublayer(dial)
    layer.addSublayer(pointer)
    dial.strokeColor = UIColor.black.cgColor
    dial.fillColor = UIColor.white.cgColor
    
    dial.shadowColor = UIColor.gray.cgColor
    dial.shadowOpacity = 0.7
    dial.shadowRadius = 8
    dial.shadowOffset = .zero
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let dialPath = UIBezierPath(ovalIn: bounds)
    dial.path = dialPath.cgPath
    let path = buildArrow(width: 10, length: bounds.midX - 20, depth: 20)
    pointer.path = path.cgPath
    pointer.strokeColor = UIColor.darkGray.cgColor
    pointer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    pointer.lineWidth = 4
    pointer.lineCap = kCALineCapRound
    
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.duration = 60
    animation.fromValue = 0
    animation.toValue = Float.pi * 2
    animation.repeatCount = .greatestFiniteMagnitude
    pointer.add(animation, forKey: "time")
  }
  
  func buildArrow(width: CGFloat, length: CGFloat, depth: CGFloat) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: .zero)
    let endPoint = CGPoint(x: 0, y: -length)
    path.addLine(to: endPoint)
    
    path.move(to: CGPoint(x: 0-width, y: endPoint.y + depth))
    path.addLine(to: endPoint)
    path.move(to: CGPoint(x: width, y: endPoint.y + depth))
    path.addLine(to: endPoint)
    
    return path
  }
  
  
  
  
  
  
  

  // method for drawing the numbers in section 2
  func draw(number: Int) {
    let string = "\(number)" as NSString
    let attributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 18)!]
    let size = string.size(withAttributes: attributes)
    string.draw(at: CGPoint(x: bounds.width/2 - size.width/2, y: 10), withAttributes: attributes)
  }

  
}

