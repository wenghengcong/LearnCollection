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

@IBDesignable
class LoginView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  func setup() {
    setupControls()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }

  // M Subviews
  
  final class TextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return makeInsetRect(bounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return makeInsetRect(bounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return makeInsetRect(bounds: bounds)
    }
    
    private func makeInsetRect(bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 20, dy: 0)
    }
    
  }
  
  let name = TextField()
  let password = TextField()
  let button = UIButton()
  
  func setupControls() {
    addSubview(name)
    addSubview(password)
    addSubview(button)
    name.backgroundColor = .white
    name.placeholder = "name"
    password.backgroundColor = .white
    password.placeholder = "password"
    password.isSecureTextEntry = true
    button.setTitle("Login", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    name.translatesAutoresizingMaskIntoConstraints = false
    var centerX = name.centerXAnchor.constraint(equalTo: centerXAnchor)
    var top = name.topAnchor.constraintEqualToSystemSpacingBelow(topAnchor, multiplier: 7)
    var width = name.widthAnchor.constraint(equalToConstant: bounds.width/1.4)
    var height = name.heightAnchor.constraint(equalToConstant: 50)
    
    NSLayoutConstraint.activate([centerX, top, width, height])
    
    password.translatesAutoresizingMaskIntoConstraints = false
    centerX = password.centerXAnchor.constraint(equalTo: centerXAnchor)
    top = password.topAnchor.constraintEqualToSystemSpacingBelow(name.topAnchor, multiplier: 8)
    width = password.widthAnchor.constraint(equalToConstant: bounds.width / 1.4)
    height = password.heightAnchor.constraint(equalToConstant: 50)
    
    NSLayoutConstraint.activate([centerX, top, width, height])
    
    button.translatesAutoresizingMaskIntoConstraints = false
    centerX = button.centerXAnchor.constraint(equalTo: centerXAnchor)
    top = button.topAnchor.constraintEqualToSystemSpacingBelow(password.topAnchor, multiplier: 10)
    width = button.widthAnchor.constraint(equalToConstant: bounds.width / 3)
    height = button.heightAnchor.constraint(equalToConstant: 44)
    
    NSLayoutConstraint.activate([centerX, top, width, height])
    
  }
}
