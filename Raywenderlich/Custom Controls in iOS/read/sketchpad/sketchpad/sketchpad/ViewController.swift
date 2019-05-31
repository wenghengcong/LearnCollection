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


import Colorgon
import DeluxeButton
import Scribble
import UIKit

final class ViewController: UIViewController {
    // 调色板
  @IBOutlet
  fileprivate private(set) weak var colorgonView: Colorgon.View!

    // 填充按钮
  @IBOutlet
  fileprivate private(set) weak var fillButton: DeluxeButton!

    //画布
  @IBOutlet
  fileprivate private(set) weak var canvas: CanvasView! {
    didSet {
      canvas.drawColor = CanvasView.makeTexturePatternColor(
        texture: #imageLiteral(resourceName: "DrawingTexture"),
        color: .black
      )
    }
  }
}

//MARK: @IBAction
private extension ViewController {
  @IBAction
  func handleFillButtonTapped() {
    canvas.canvasColor = fillButton.unpressedBackgroundColor
  }
}

//MARK: UIViewController
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    colorgonView.handleColorSelection = {
      [unowned self] color in
      
      self.canvas.drawColor = CanvasView.makeTexturePatternColor(
        texture: #imageLiteral(resourceName: "DrawingTexture"),
        color: color
      )
      
      self.fillButton.unpressedBackgroundColor = color
      self.fillButton.pressedBackgroundColor = color.highlighted
      self.fillButton.tintColor =
        self.colorgonView.value < 0.25
        ? UIColor(white: 0.6, alpha: 1)
        : .black
    }
  }
}

//MARK:
private extension UIColor {
  var highlighted: UIColor {
    var hue = CGFloat()
    var saturation = CGFloat()
    var brightness = CGFloat()
    var alpha = CGFloat()
    
    getHue(
      &hue,
      saturation: &saturation,
      brightness: &brightness,
      alpha: &alpha
    )
    
    return UIColor(
      hue: hue,
      saturation: saturation * 0.4,
      brightness: brightness * 1.2,
      alpha: alpha
    )
  }
}
