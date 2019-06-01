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
class AvatarView: UIView {
  
  let margin: CGFloat = 30.0
  let labelName = UILabel()
  let imageView = UIImageView()
  
  
  @IBInspectable var imageAvatar: UIImage? {
    didSet {
      configure()
    }
  }
  
  @IBInspectable var avatarName: String = "" {
    didSet {
      configure()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }

  func setup() {
    
    // Setup image view
    imageView.contentMode = .ScaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    // Setup label
    labelName.font = UIFont(name: "AvenirNext-Bold", size: 28.0)
    labelName.textColor = UIColor.blackColor()
    labelName.translatesAutoresizingMaskIntoConstraints = false
    addSubview(labelName)
    
    labelName.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
    
    // Add constraints for label
    let labelCenterX = labelName.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
    let labelBottom = labelName.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
    NSLayoutConstraint.activateConstraints([labelCenterX, labelBottom])
    
    // Add constraints for imageView
    let imageViewCenterX = imageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
    let imageViewTop = imageView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: margin)
    let imageViewBottom = imageView.bottomAnchor.constraintEqualToAnchor(labelName.topAnchor, constant: -margin)
    let imageViewWidth = imageView.widthAnchor.constraintEqualToAnchor(imageView.heightAnchor)
    NSLayoutConstraint.activateConstraints([imageViewCenterX, imageViewTop, imageViewBottom, imageViewWidth])
  }
  
  func configure() {

    // Configure image view and label
    imageView.image = imageAvatar
    labelName.text = avatarName
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
}
