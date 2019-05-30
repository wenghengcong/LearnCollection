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

@IBDesignable
public final class DeluxeButton: UIControl {
//MARK: public
  @IBInspectable
  public var pressedBackgroundColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  
  @IBInspectable
  public var unpressedBackgroundColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
    didSet {
      backgroundColor = unpressedBackgroundColor
    }
  }
  
//MARK: fileprivate
  fileprivate let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  fileprivate let label: UILabel = {
    let label = UILabel()

    label.font = UIFont.systemFont(
      ofSize: 40.0,
      weight: UIFontWeightHeavy
    )
    label.textAlignment = .center
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }()
  
  fileprivate lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [self.imageView, self.label])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isUserInteractionEnabled = false
    stackView.axis = .vertical
    return stackView
  }()
  
//MARK: init
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    initPhase2()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    initPhase2()
  }
  
  private func initPhase2() {
    label.backgroundColor = tintColor
    layer.borderColor = tintColor.cgColor
    layer.cornerRadius = 20
    clipsToBounds = true
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
      stackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
      label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
    ])
  }
}

public extension DeluxeButton {
  @IBInspectable
  var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
    }
  }
  
  @IBInspectable
  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }
  
  @IBInspectable
  var fontSize: CGFloat {
    get {
      return label.font.pointSize
    }
    set {
      label.font = UIFont.systemFont(ofSize: newValue, weight: UIFontWeightHeavy)
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layoutMargins = UIEdgeInsets(
        top: newValue,
        left: newValue,
        bottom: newValue / 2,
        right: newValue
      )
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var imagePadding: CGFloat {
    get {
      return image?.alignmentRectInsets.top ?? 0
    }
    set {
      image = image?.withAlignmentRectInsets(
        UIEdgeInsets(
          top: -newValue,
          left: -newValue,
          bottom: -newValue,
          right: -newValue
        )
      )
    }
  }
  
  override func tintColorDidChange() {
    label.backgroundColor = tintColor
    layer.borderColor = tintColor.cgColor
  }
}

//MARK: UIControl
public extension DeluxeButton {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    animate(isPressed: true)
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    feedbackGenerator.impactOccurred()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    animate(isPressed: false)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    animate(isPressed: false)
  }
  
//MARK: private
  private func animate(isPressed: Bool) {
    let (
      duration,
      backgroundColor,
      labelIsHidden
    ) = {
      isPressed
      ? (
        duration: 0.05,
        backgroundColor: pressedBackgroundColor,
        labelIsHidden: true
      )
      : (
        duration: 0.1,
        backgroundColor: unpressedBackgroundColor,
        labelIsHidden: false
      )
    }()
    
    UIView.animate(withDuration: duration){
      self.backgroundColor = backgroundColor
      self.label.isHidden = labelIsHidden
    }
  }
}
