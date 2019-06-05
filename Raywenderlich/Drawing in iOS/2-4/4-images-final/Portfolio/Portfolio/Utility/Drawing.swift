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

class Drawing {
  class func cupcake(frame: CGRect = CGRect(x: 1, y: 0, width: 240, height: 240)) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: frame.size)
    
    let image = renderer.image { canvas in
      //// Color Declarations
      let brown = UIColor(red: 0.606, green: 0.427, blue: 0.108, alpha: 1.000)
      let pink = UIColor(red: 0.979, green: 0.789, blue: 0.789, alpha: 1.000)
      let red = UIColor(red: 0.858, green: 0.264, blue: 0.264, alpha: 1.000)
      
      //// cake Drawing
      let cakePath = UIBezierPath()
      cakePath.move(to: CGPoint(x: frame.minX + 0.09400 * frame.width, y: frame.minY + 0.55459 * frame.height))
      cakePath.addLine(to: CGPoint(x: frame.minX + 0.25418 * frame.width, y: frame.minY + 0.96875 * frame.height))
      cakePath.addLine(to: CGPoint(x: frame.minX + 0.73471 * frame.width, y: frame.minY + 0.96875 * frame.height))
      cakePath.addLine(to: CGPoint(x: frame.minX + 0.88517 * frame.width, y: frame.minY + 0.55459 * frame.height))
      cakePath.addLine(to: CGPoint(x: frame.minX + 0.09400 * frame.width, y: frame.minY + 0.55459 * frame.height))
      cakePath.close()
      brown.setFill()
      cakePath.fill()
      UIColor.black.setStroke()
      cakePath.lineWidth = 1
      cakePath.stroke()
      
      
      //// frosting Drawing
      let frostingPath = UIBezierPath()
      frostingPath.move(to: CGPoint(x: frame.minX + 0.41435 * frame.width, y: frame.minY + 0.64939 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.30272 * frame.width, y: frame.minY + 0.59451 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.37067 * frame.width, y: frame.minY + 0.65438 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.37067 * frame.width, y: frame.minY + 0.59451 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.17652 * frame.width, y: frame.minY + 0.63443 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.23476 * frame.width, y: frame.minY + 0.59451 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.24262 * frame.width, y: frame.minY + 0.61260 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.05032 * frame.width, y: frame.minY + 0.59451 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.11042 * frame.width, y: frame.minY + 0.65625 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.07355 * frame.width, y: frame.minY + 0.71609 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.16195 * frame.width, y: frame.minY + 0.27515 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.02708 * frame.width, y: frame.minY + 0.47292 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.05933 * frame.width, y: frame.minY + 0.35238 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.47745 * frame.width, y: frame.minY + 0.17036 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.26458 * frame.width, y: frame.minY + 0.19792 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.36582 * frame.width, y: frame.minY + 0.17036 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.82207 * frame.width, y: frame.minY + 0.27515 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.58909 * frame.width, y: frame.minY + 0.17036 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.72985 * frame.width, y: frame.minY + 0.20030 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.94375 * frame.width, y: frame.minY + 0.47708 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.91430 * frame.width, y: frame.minY + 0.35000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.93125 * frame.width, y: frame.minY + 0.41042 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.87061 * frame.width, y: frame.minY + 0.68931 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.95625 * frame.width, y: frame.minY + 0.54375 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.91915 * frame.width, y: frame.minY + 0.68931 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.73471 * frame.width, y: frame.minY + 0.59451 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.82207 * frame.width, y: frame.minY + 0.68931 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.80266 * frame.width, y: frame.minY + 0.59451 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.63958 * frame.width, y: frame.minY + 0.63542 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.69689 * frame.width, y: frame.minY + 0.59451 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.66974 * frame.width, y: frame.minY + 0.64227 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.55511 * frame.width, y: frame.minY + 0.56956 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.61555 * frame.width, y: frame.minY + 0.62995 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.58956 * frame.width, y: frame.minY + 0.56956 * frame.height))
      frostingPath.addCurve(to: CGPoint(x: frame.minX + 0.41435 * frame.width, y: frame.minY + 0.64939 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.47745 * frame.width, y: frame.minY + 0.56956 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.45804 * frame.width, y: frame.minY + 0.64441 * frame.height))
      frostingPath.close()
      pink.setFill()
      frostingPath.fill()
      UIColor.black.setStroke()
      frostingPath.lineWidth = 1
      frostingPath.stroke()
      
      
      //// Cherry Drawing
      let cherryPath = UIBezierPath()
      cherryPath.move(to: CGPoint(x: frame.minX + 0.48266 * frame.width, y: frame.minY + 0.08992 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.10473 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.49714 * frame.width, y: frame.minY + 0.09486 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.10473 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.52612 * frame.width, y: frame.minY + 0.08992 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.10473 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.51646 * frame.width, y: frame.minY + 0.09486 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.58408 * frame.width, y: frame.minY + 0.11460 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.54034 * frame.width, y: frame.minY + 0.08266 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.56959 * frame.width, y: frame.minY + 0.08992 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.24788 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.60841 * frame.width, y: frame.minY + 0.15606 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.58891 * frame.width, y: frame.minY + 0.24295 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.42470 * frame.width, y: frame.minY + 0.11460 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.42470 * frame.width, y: frame.minY + 0.25282 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.39089 * frame.width, y: frame.minY + 0.16890 * frame.height))
      cherryPath.addCurve(to: CGPoint(x: frame.minX + 0.48266 * frame.width, y: frame.minY + 0.08992 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44359 * frame.width, y: frame.minY + 0.08426 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.46431 * frame.width, y: frame.minY + 0.08367 * frame.height))
      cherryPath.close()
      red.setFill()
      cherryPath.fill()
      UIColor.black.setStroke()
      cherryPath.lineWidth = 1
      cherryPath.stroke()
      
      
      //// stalk Drawing
      let stalkPath = UIBezierPath()
      stalkPath.move(to: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.10473 * frame.height))
      stalkPath.addCurve(to: CGPoint(x: frame.minX + 0.52772 * frame.width, y: frame.minY + 0.05461 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.50680 * frame.width, y: frame.minY + 0.10473 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50476 * frame.width, y: frame.minY + 0.08160 * frame.height))
      stalkPath.addCurve(to: CGPoint(x: frame.minX + 0.58408 * frame.width, y: frame.minY + 0.03533 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.55068 * frame.width, y: frame.minY + 0.02762 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.58408 * frame.width, y: frame.minY + 0.03533 * frame.height))
      UIColor.black.setStroke()
      stalkPath.lineWidth = 1
      stalkPath.stroke()
    }
    return image
  }
  
  
}


