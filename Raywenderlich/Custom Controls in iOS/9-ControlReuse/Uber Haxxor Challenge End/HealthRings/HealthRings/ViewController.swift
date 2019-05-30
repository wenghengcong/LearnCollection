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
import ThreeRingControl

final class ViewController: UIViewController {
  @IBOutlet
  fileprivate weak var threeRingView: ThreeRingView!

  @IBOutlet
  fileprivate weak var animationEnabledSwitch: UISwitch!
  
  @IBOutlet
  fileprivate weak var durationSlider: UISlider!
  
  @IBOutlet
  fileprivate var valueSliders: [UISlider]!
}

//MARK: internal
extension ViewController {
  @IBAction
  func handleUpdateButtonTapped() {
    let values = valueSliders.map{CGFloat($0.value)}
    
    if animationEnabledSwitch.isOn {
      threeRingView.animationDuration = TimeInterval(durationSlider.value)
      
      for (ring, value) in zip(rings, values) {
        threeRingView.animate(
          ring: ring,
          value: value
        )
      }
    } else {
      threeRingView.innerRingValue = values[0]
      threeRingView.middleRingValue = values[1]
      threeRingView.outerRingValue = values[2]
    }
  }
}

//MARK: UIViewController
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    handleUpdateButtonTapped()
    
    let colors = [threeRingView.innerRingColor, threeRingView.middleRingColor, threeRingView.outerRingColor]
    for (slider, color) in zip(valueSliders, colors) {
      slider.thumbTintColor = color
      slider.minimumTrackTintColor = color.darkened
    }
  }
}
