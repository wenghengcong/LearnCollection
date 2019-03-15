/**
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
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Cocoa

class QuotesViewController: NSViewController {
  //connect to label
  @IBOutlet var textLabel: NSTextField!
  let quotes = Quote.all
  
  var currentQuoteIndex: Int = 0 {
    didSet {
      updateQuote()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentQuoteIndex = 0
  }
  
  func updateQuote() {
    textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
  }
}

extension QuotesViewController {
  @IBAction func previous(_ sender: NSButton) {
    currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
  }
  
  @IBAction func next(_ sender: NSButton) {
    currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
  }
  
  @IBAction func quit(sender: NSButton) {
    NSApplication.shared.terminate(sender)
  }
}

extension QuotesViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> QuotesViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier(rawValue: "QuotesViewController")
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? QuotesViewController else {
      fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
