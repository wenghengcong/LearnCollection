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
  
  var image: UIImage?
  @IBInspectable var rating: Int = 0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var cross: UIImage {
    let size = 40
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
    return renderer.image { context in
      let cgcontext = context.cgContext
      cgcontext.addLines(between: [.zero, CGPoint(x: size, y: size)])
      cgcontext.addLines(between: [CGPoint(x: size, y: 0),
                                   CGPoint(x: 0, y: size)])
      cgcontext.setStrokeColor(UIColor.white.cgColor)
      cgcontext.strokePath()
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    image = Drawing.cupcake(frame: bounds)
  }
  
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    context?.saveGState()
    context?.scaleBy(x: 0.25, y: 0.25)

    context?.saveGState()
    for _ in 0..<4 {
      image?.draw(at: .zero)
      context?.translateBy(x: rect.width, y: 0)
    }
    context?.restoreGState()
    context?.restoreGState()
    
    
    context?.saveGState()
    context?.scaleBy(x: 0.25, y: 0.25)
    context?.scaleBy(x: 1, y: -1)
    context?.translateBy(x: 0, y: -rect.height)
    for i in 0..<4 {
      if i >= rating {
        context?.saveGState()
        context?.clip(to: rect, mask: image!.cgImage!)
        UIColor.red.setFill()
        UIRectFill(rect)
        cross.drawAsPattern(in: rect)
        context?.restoreGState()
      }
      context?.translateBy(x: rect.width, y: 0)
    }
    context?.restoreGState()
    
  }
  
  @objc func handleTap(gesture: UITapGestureRecognizer) {
    let width = bounds.width * 0.25
    let location = gesture.location(in: self).x / width
    rating = Int(location) + 1
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
  }
}






























