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

let π = CGFloat(Double.pi)

@IBDesignable
public final class CanvasView: UIImageView {
  
  // Parameters
  fileprivate let defaultLineWidth: CGFloat = 10
    
  /// 按压临界值：小于该值绘制阴影，否则绘制线条
  fileprivate let forceSensitivity: CGFloat = 4.0
  fileprivate let tiltThreshold = π/6               // 30º
  fileprivate let minLineWidth: CGFloat = 5
  
  fileprivate var drawingImage: UIImage?
  
  public var drawColor: UIColor = .black
  
  @IBInspectable
  public var canvasColor: UIColor = .cyan {
    didSet {
      fill(color: canvasColor.cgColor)
    }
  }
  
  fileprivate var eraserColor: UIColor {
    return backgroundColor ?? UIColor.white
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    isUserInteractionEnabled = true
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
    
  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    // Draw previous image into context
    // 绘制之前的图像
    drawingImage?.draw(in: bounds)
    
    // 1
    var touches = [UITouch]()
    
    // Coalesce Touches
    // 苹果在iPad Air 2的触控屏幕上加快了对触控事件的扫描频率，比起之前的iPad快上一倍，但是，运行循环的速度并没有改变，因此，在iOS 9的API中，会把这些比以前来得多的触控事件，变成UIEvent中的coalescedTouches
    // 2 coalescedTouches用于更高精度的获取触摸的touch
    if let coalescedTouches = event?.coalescedTouches(for: touch) {
      touches = coalescedTouches
    } else {
      touches.append(touch)
    }
    
    // 4
    for touch in touches {
        // 绘制每个手指划过的痕迹
      drawStroke(context, touch: touch)
    }
    
    // 1 获取当前上下文生成的图像
    drawingImage = UIGraphicsGetImageFromCurrentImageContext()
    // 2 预测触摸的数组
    if let predictedTouches = event?.predictedTouches(for: touch) {
      for touch in predictedTouches {
        drawStroke(context, touch: touch)
      }
    }
    
    // Update image
    image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // 设置image不影响图层上的显示
    image = drawingImage
  }
  
  override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    // 设置image不影响图层上的显示
    image = drawingImage
  }
  
  fileprivate func drawStroke(_ context: CGContext?, touch: UITouch) {
    // 手指之前的位置
    let previousLocation = touch.previousLocation(in: self)
    // 当前的位置
    let location = touch.location(in: self)
    
    // Calculate line width for drawing stroke
    // 处理线条的宽度
    var lineWidth: CGFloat
    if touch.type == .stylus {
        //用pencil绘制
      if touch.altitudeAngle < tiltThreshold {
        lineWidth = lineWidthForShading(context, touch: touch)
      } else {
        lineWidth = lineWidthForDrawing(context, touch: touch)
      }
    } else {
      // Draw with finger
      lineWidth = touch.majorRadius < 10
        ? defaultLineWidth
        : touch.majorRadius / 2
    }
    
    // Set color
    drawColor.setStroke()
    
    // Configure line
    context?.setLineWidth(lineWidth)
    context?.setLineCap(.round)

    
    // Set up the points
    context?.move(to: CGPoint(x: previousLocation.x, y: previousLocation.y))
    context?.addLine(to: CGPoint(x: location.x, y: location.y))
    // Draw the stroke
    context?.strokePath()
    
  }
  
    
  /// 绘制阴影
  fileprivate func lineWidthForShading(_ context: CGContext?, touch: UITouch) -> CGFloat {
    
    // 1
    let previousLocation = touch.previousLocation(in: self)
    let location = touch.location(in: self)
    
    // 2 - vector1 is the pencil direction
    let vector1 = touch.azimuthUnitVector(in: self)
    
    // 3 - vector2 is the stroke direction
    let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
    
    // 4 - Angle difference between the two vectors
    var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))
    
    // 5
    if angle > π {
      angle = 2 * π - angle
    }
    if angle > π / 2 {
      angle = π - angle
    }
    
    // 6
    let minAngle: CGFloat = 0
    let maxAngle = π / 2
    let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)
    
    // 7
    let maxLineWidth: CGFloat = 60
    var lineWidth = maxLineWidth * normalizedAngle
    
    // 1 - modify lineWidth by altitude (tilt of the Pencil)
    // 0.25 radians means widest stroke and TiltThreshold is where shading narrows to line.
    
    let minAltitudeAngle: CGFloat = 0.25
    let maxAltitudeAngle = tiltThreshold
    
    // 2
    let altitudeAngle = touch.altitudeAngle < minAltitudeAngle
      ? minAltitudeAngle : touch.altitudeAngle
    
    // 3 - normalize between 0 and 1
    let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle)
      / (maxAltitudeAngle - minAltitudeAngle))
    // 4
    lineWidth = lineWidth * normalizedAltitude + minLineWidth
    
    // Set alpha of shading using force
    let minForce: CGFloat = 0.0
    let maxForce: CGFloat = 5
    
    // Normalize between 0 and 1
    let normalizedAlpha = (touch.force - minForce) / (maxForce - minForce)
    
    context?.setAlpha(normalizedAlpha)
    
    return lineWidth
  }
  
  
    
  /// 绘制线条
  fileprivate func lineWidthForDrawing(_ context: CGContext?, touch: UITouch) -> CGFloat {

    var lineWidth = defaultLineWidth
    
    if touch.force > 0 {  // If finger, touch.force = 0
      lineWidth = touch.force * forceSensitivity
    }
    
    return lineWidth
  }
  
  func clearCanvas(animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.5, animations: {
        self.alpha = 0
        }, completion: { finished in
          self.alpha = 1
          self.image = nil
          self.drawingImage = nil
      })
    } else {
      self.image = nil
      self.drawingImage = nil
    }
  }
  
    
  /// 用颜色绘制画布
  fileprivate func fill(color: CGColor) {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    
    drawingImage?.draw(in: bounds)
    
    let context = UIGraphicsGetCurrentContext()
    
    context?.setFillColor(color)
    context?.fill(bounds)
    
    drawingImage = UIGraphicsGetImageFromCurrentImageContext()
    
    layer.contents = drawingImage?.cgImage
    
    UIGraphicsEndImageContext()
  }
}

public extension CanvasView {
    
  /// 返回纹理图片处理后的颜色
  static func makeTexturePatternColor(
    texture: UIImage,   // 纹理图片
    color: UIColor      // 需要处理的颜色
  ) -> UIColor {
    return UIColor( patternImage: texture.imageWithColor(color) )
  }
}

public extension UIImage {
  func imageWithColor(_ color: UIColor) -> UIImage {
    var image = withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.setFill()
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}
