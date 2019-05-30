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


import QuartzCore
import CoreImage

final class Layer: CALayer {
//MARK: fileprivate
  fileprivate let ciContext = CIContext()
  
  fileprivate let kernel = CIColorKernel(string:
    "kernel vec4 makeColorgon(float width, float height) {" +
      "vec2 position = destCoord() / vec2(width, height);" +
      "position.y = 1. - position.y;" +
      "position = 2. * position - 1.;" +
      
      "vec2 cyanVertexPosition = vec2(.8660254038, .5);" +
      "float rightVertexXInverse = 1. / cyanVertexPosition.x;" +
      "vec2 maskSteps;" +
      "float mask;" +

      "vec2 redFaceOrigin = -cyanVertexPosition;" +
      "vec2 redToWhitePosition = mat2(" +
        "vec2(rightVertexXInverse, cyanVertexPosition.y * rightVertexXInverse)," +
        "vec2(0, 1)" +
      ") * (position - redFaceOrigin);" +
      "maskSteps = step(0., 1. - redToWhitePosition);" +
      "mask = min(maskSteps.x, maskSteps.y);" +
      "vec3 redFaceColor = vec3(mask, redToWhitePosition.yx * mask);" +
      
      "vec2 greenFaceOrigin = vec2(0, 1);" +
      "float xContribution = rightVertexXInverse * cyanVertexPosition.y;" +
      "vec2 greenToWhitePosition = mat2(" +
        "vec2(-xContribution, xContribution)," +
        "vec2(-1, -1)" +
      ") * (position - greenFaceOrigin);" +
      "maskSteps = step(0., 1. - greenToWhitePosition);" +
      "mask = min(maskSteps.x, maskSteps.y);" +
      "vec3 greenFaceColor = vec3(greenToWhitePosition.x, mask, greenToWhitePosition.y);" +
      "greenFaceColor.rb *= mask;" +
      
      "vec2 blueFaceOrigin = vec2(cyanVertexPosition.x, -cyanVertexPosition.y);" +
      "vec2 blueToWhitePosition = mat2(" +
        "vec2(-rightVertexXInverse, cyanVertexPosition.y * -rightVertexXInverse)," +
        "vec2(0, 1)" +
      ") * (position - blueFaceOrigin);" +
      "maskSteps = step(0., 1. - blueToWhitePosition);" +
      "mask = min(maskSteps.x, maskSteps.y);" +
      "vec3 blueFaceColor = vec3(blueToWhitePosition * mask, mask);" +
      
      "vec3 fullValueColor = redFaceColor + greenFaceColor + blueFaceColor;" +
      "return vec4(fullValueColor, 1);" +
    "}"
  )!
  
//MARK: init
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init() {
    super.init()
    needsDisplayOnBoundsChange = true
  }
}

//MARK: CALayer
extension Layer {
  override func draw(in cgContext: CGContext) {
    guard
      let ciImage = kernel.apply(
        withExtent: CGRect(
          origin: .zero,
          size: bounds.size
        ),
        arguments: [bounds.width, bounds.height]
      ),
      let cgImage = ciContext.createCGImage(
        ciImage,
        from: bounds
      )
    else {return}
    
    mask = {
      let mask = CAShapeLayer()
      
      let path = CGMutablePath()
      path.addLines(
        between: stride(
          from: CGFloat.pi / 6,
          to: 2 * .pi,
          by: .pi / 3
        ).map{
          angle in CGPoint(
            x: cos(angle),
            y: sin(angle)
          )
        },
        transform: CGAffineTransform(
          scaleX: bounds.width / 2,
          y: bounds.height / 2
        ).translatedBy(
          x: 1,
          y: 1
        )
      )
      path.closeSubpath()
      mask.path = path
      
      return mask
    }()
    
    cgContext.draw(
      cgImage,
      in: bounds
    )
  }
}
