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


import UIKit

public final class CircularGradientLayer: CALayer {
  public var color = UIColor.white.cgColor {
    didSet {
      setNeedsDisplay()
    }
  }

//MARK: fileprivate
  fileprivate let ciContext = CIContext(
    options: [kCIContextUseSoftwareRenderer: false]
  )
  
  fileprivate let filter = Filter()
  
//MARK: init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }
  
  public override init() {
    super.init()
    initPhase2()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    initPhase2()
    
    if let layer = layer as? CircularGradientLayer {
      color = layer.color
    }
  }
  
  private func initPhase2() {
    needsDisplayOnBoundsChange = true
  }
}

//MARK: CALayer
public extension CircularGradientLayer {
  override func draw(in context: CGContext) {
    super.draw(in: context)
    
    filter.outputSize = bounds.size
    filter.color = color
    let image = ciContext.createCGImage(
      filter.outputImage,
      from: bounds
    )
    context.draw(image!, in: bounds)
  }
}

//MARK:-
private final class Filter: CIFilter {
  var color: CGColor!
  var outputSize: CGSize!
  
  lazy var kernel = CIColorKernel(string:
    "kernel vec4 chromaKey(__color c1, __color c2, float width, float height) {" +
      "vec2 dimensions = vec2(width, height);" +
      "vec2 xy = 1.0 - 2.0 * destCoord() / dimensions;" +
      "float prop = atan(xy.y, xy.x) / (3.1415926535897932 * 2.0) + 0.5;" +
      "return mix(c2, c1, prop);" +
    "}"
  )!
}

//MARK: CIFilter
extension Filter {
  override var outputImage: CIImage {
    return kernel.apply(
      withExtent: CGRect(
        origin: .zero,
        size: outputSize
      ),
      arguments: [
        CIColor(cgColor: color),
        CIColor(darkening: color),
        outputSize.width,
        outputSize.height
      ]
    )!
  }
}
