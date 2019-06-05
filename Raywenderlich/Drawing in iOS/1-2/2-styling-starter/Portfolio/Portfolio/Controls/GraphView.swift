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
class GraphView: UIView {
  
  var days: [CGFloat] = [4, 3, 0, 6, 5, 10, 8]
  
  // number of y axis labels
  let yDivisions: CGFloat = 5
  // margin between lines
  lazy var gap: CGFloat = {
    return bounds.height / (yDivisions + 1)
  }()
  // averaged value spread over y Divisions
  lazy var eachLabel: CGFloat = {
    let maxValue = CGFloat(days.max()!)
    let minValue = CGFloat(days.min()!)
    return (maxValue - minValue) / (yDivisions-1)
  }()
  // column width
  lazy var columnWidth: CGFloat = {
    return bounds.width / CGFloat(days.count)
  }()

  override func draw(_ rect: CGRect) {
    
  }
  
  func drawGradient(context: CGContext) {
  }
  
  func drawText(context: CGContext) {
  }
  
}


