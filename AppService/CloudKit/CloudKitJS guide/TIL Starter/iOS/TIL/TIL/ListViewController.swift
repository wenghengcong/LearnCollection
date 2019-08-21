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

import UIKit
import CloudKit

class ListViewController: UITableViewController {
  
  let model = Model.sharedInstance()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewObject))
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
    navigationItem.rightBarButtonItems = [addButton, refreshButton]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    model.delegate = self
    model.refreshPublicDB()
  }
  
  // MARK: - Bar button functions
  
  func refreshList() {
    model.refreshPublicDB()
  }
  
  func addNewObject() {
    let alert = UIAlertController(title: "NEW", message: "Today I Learned", preferredStyle: .alert)
    
    alert.addTextField { shortField in
      shortField.placeholder = "TIL"
      shortField.autocapitalizationType = .allCharacters
      shortField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
    }

    alert.addTextField { longField in
      longField.placeholder = "Today I Learned"
      longField.autocapitalizationType = .words
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    let addAction = UIAlertAction(title: "Add", style: .default) { action in
      guard let text = alert.textFields?[1].text , !text.isEmpty else {
        print("No long form entered")
        return
      }

      guard let shortText = alert.textFields?.first?.text,
        let longText = alert.textFields?[1].text else {
          return
      }

      let newObject = Acronym(short: shortText, long: longText)
      self.model.items.append(newObject)

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }

      self.model.publicDB.save(newObject.record!, completionHandler: { _, error in
        if let error = error {
          print(error)
        }
      }) 
    }

    addAction.isEnabled = false
    alert.addAction(addAction)
    present(alert, animated: true, completion: nil)
  }

  func alertTextFieldDidChange(_ sender: UITextField) {
    let controller = presentedViewController as! UIAlertController
    if let input = sender.text {
      if input.characters.count < 1 {
        (controller.actions.last! as UIAlertAction).isEnabled = false
        return
      }
    }
    (controller.actions.last! as UIAlertAction).isEnabled = true
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
    
    let object = model.items[(indexPath as NSIndexPath).row]
    cell.textLabel?.text = object.short
    cell.detailTextLabel?.text = object.long
    
    return cell
  }
  
  // Convenience method to delete items during development
  // Shouldn't let real users delete items from publicDB
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let removedItem = model.items.remove(at: (indexPath as NSIndexPath).row)
      model.publicDB.delete(withRecordID: (removedItem.record?.recordID)!) { record, error in
        if let error = error {
          print(error)
        }
      }
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
}

extension ListViewController: ModelDelegate {
  func publicDBUpdated() {
    tableView.reloadData()
  }
  
  func errorUpdating(_ error: NSError) {
    print(error)
  }
  
}
