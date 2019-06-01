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

class BookViewController : UIViewController {
  
  @IBOutlet weak var bookTitleLabel: UILabel!
  @IBOutlet weak var bookImageView: UIImageView!
  @IBOutlet weak var bookAuthorsLabel: UILabel!
  @IBOutlet weak var stepper: UIStepper!
  @IBOutlet weak var statView: StatView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var doneButton: UIButton!
  
  var book: Book?
  
  override func viewWillAppear(animated: Bool) {
    
    doneButton.layer.cornerRadius = CGRectGetHeight(doneButton.bounds)/2.0
    bookImageView.layer.borderColor = UIColor.blackColor().CGColor
    bookImageView.layer.borderWidth = 1.0
    
    guard let book = book else {
      return
    }
    
    bookImageView.image = book.cover
    bookTitleLabel.text = book.title
    bookAuthorsLabel.text = book.authors
    
    statView.range = CGFloat(book.chaptersTotal)
    statView.curValue = CGFloat(book.chaptersRead)
    stepper.value = Double(book.chaptersRead)
    stepper.maximumValue = Double(book.chaptersTotal)
  }
  
  @IBAction func stepperValueDidChange(stepper: UIStepper) {
    statView.curValue = CGFloat(stepper.value)
  }
}