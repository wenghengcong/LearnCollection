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

@IBDesignable
class StatView: UIView {
  
  let percentLabel = UILabel()
  let captionLabel = UILabel()
  
  var range: CGFloat = 10
  var curValue: CGFloat = 0 {
    didSet {
      configure()
    }
  }
  let margin: CGFloat = 10
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
    configure()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
    configure()
  }
  
  func setup() {
    
    // Setup percent label
    percentLabel.font = UIFont.systemFontOfSize(26)
    percentLabel.textColor = UIColor.whiteColor()
    percentLabel.text = "0/0"
    percentLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(percentLabel)
    
    // Setup caption label
    captionLabel.font = UIFont.systemFontOfSize(26)
    captionLabel.text = "Chapters Read"
    captionLabel.textColor = UIColor.whiteColor()
    captionLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(captionLabel)
    
    // Setup constraints
    let percentLabelCenterX = percentLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
    let percentLabelCenterY = percentLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: -margin)
    NSLayoutConstraint.activateConstraints([percentLabelCenterX, percentLabelCenterY])
    
    let captionLabelCenterX = captionLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: -margin)
    let captionLabelBottom = captionLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -margin)
    NSLayoutConstraint.activateConstraints([captionLabelCenterX, captionLabelBottom])
  }
  
  func configure() {
    percentLabel.text = String(format: "%.0f/%.0f", curValue, range)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
}