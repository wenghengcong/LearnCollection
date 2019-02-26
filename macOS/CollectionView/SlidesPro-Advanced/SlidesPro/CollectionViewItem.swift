/*
 * CollectionViewItem.swift
 * SlidesPro
 *
 * Created by Gabriel Miro on 30/3/16.
 * Copyright (c) 2016 Razeware LLC
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

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  
  var imageFile: ImageFile? {
    didSet {
      guard isViewLoaded else { return }
      if let imageFile = imageFile {
        imageView?.image = imageFile.thumbnail
        textField?.stringValue = imageFile.fileName
      } else {
        imageView?.image = nil
        textField?.stringValue = ""
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.lightGray.cgColor
    view.layer?.borderWidth = 0.0
    view.layer?.borderColor = NSColor(calibratedRed: 0.0, green: 0.5, blue: 1.0, alpha: 1.0).cgColor // Aqua
  }
  
  func setHighlight(selected: Bool) {
      view.layer?.borderWidth = selected ? 5.0 : 0.0
  }
  
}
