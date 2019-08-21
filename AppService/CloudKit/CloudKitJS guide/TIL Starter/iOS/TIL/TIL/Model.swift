/*
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

import Foundation
import CloudKit

protocol ModelDelegate {
  func errorUpdating(_ error: NSError)
  func publicDBUpdated()
}

final class Model {

  let container: CKContainer
  let publicDB: CKDatabase

  init() {
    container = CKContainer.default()
    publicDB = container.publicCloudDatabase
  }

  var items: [Acronym] = []

  // MARK: - Model singleton

  static let _sharedInstance = Model()
  class func sharedInstance() -> Model {
    return _sharedInstance
  }

  var delegate: ModelDelegate?

  func refreshPublicDB() {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Acronym", predicate: predicate)
    publicDB.perform(query, inZoneWith: nil) { results, error in
      if let error = error {
        DispatchQueue.main.async {
          self.delegate?.errorUpdating(error as NSError)
        }
      } else {
        self.items.removeAll(keepingCapacity: true)
        for record in results! {
          let item = Acronym(record: record)
          self.items.append(item)
        }
        DispatchQueue.main.async {
          self.delegate?.publicDBUpdated()
        }
      }
    }
  }

}
