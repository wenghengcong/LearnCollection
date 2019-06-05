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
class RatingView: UIView {
  
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 10, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.width / 5, y: rect.height - 10))
    path.addLine(to: CGPoint(x: rect.width / 5 * 4, y: rect.height - 10))
    path.addLine(to: CGPoint(x: rect.width - 10, y: rect.midY))
    path.close()
    UIColor.black.setStroke()
    path.lineWidth = 3
    #colorLiteral(red: 0.8439999819, green: 0.7200000286, blue: 0.52700001, alpha: 1).setFill()
    path.fill()

    path.stroke()
    
    let top = UIBezierPath()
    top.move(to: CGPoint(x: rect.width - 10, y: rect.midY))
    var controlPoint1 = CGPoint(x: rect.width, y: rect.height/5)
    var controlPoint2 = CGPoint(x: rect.width/3*2, y: rect.height/8)
    
    top.addCurve(to: CGPoint(x: rect.midX, y: 0),
                 controlPoint1: controlPoint1,
                 controlPoint2: controlPoint2)
    
    controlPoint1 = CGPoint(x: rect.width/3, y: rect.height/8)
    controlPoint2 = CGPoint(x: 0, y: rect.height/5)
    top.addCurve(to: CGPoint(x: 10, y: rect.midY),
                 controlPoint1: controlPoint1,
                 controlPoint2: controlPoint2)

    top.close()

    top.lineWidth = 3
    #colorLiteral(red: 1, green: 0.6919999719, blue: 0.9890000224, alpha: 1).setFill()
    top.fill()
    top.stroke()
  }
}

















// drawing code 1


// drawing code 2

















