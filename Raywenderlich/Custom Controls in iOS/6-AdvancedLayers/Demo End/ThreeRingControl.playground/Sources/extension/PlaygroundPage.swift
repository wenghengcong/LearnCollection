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


import PlaygroundSupport
import UIKit

public extension PlaygroundPage {
  ///- Returns: PlaygroundPage.current.liveView
  static func set(
    layers: CALayer...,
    dimension: Int = 300,
    padding: Int = 5
  ) -> UIView {
    let view = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: dimension,
        height:
          dimension * layers.count
          + padding * (layers.count - 1)
      )
    )
    
    let halfDimension = dimension / 2
    for (index, layer) in layers.enumerated() {
      layer.bounds = CGRect(
        x: 0,
        y: 0,
        width: dimension,
        height: dimension
      )
      layer.position = CGPoint(
        x: halfDimension,
        y:
          halfDimension
          + (dimension + padding) * index
      )
      
      view.layer.addSublayer(layer)
    }
    
    PlaygroundPage.current.liveView = view
    
    return view
  }
}
