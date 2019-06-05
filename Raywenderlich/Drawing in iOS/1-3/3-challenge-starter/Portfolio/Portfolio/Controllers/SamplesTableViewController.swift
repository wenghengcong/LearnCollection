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

class SamplesTableViewController: UITableViewController {
  
  private let sampleNames = ["Thermometer", "Budget", "Clock", "Login", "Rating", "Graph"]
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let preview = UIStoryboard(name: "Preview", bundle: nil)
    let sample = sampleNames[indexPath.row]
    let controller = preview.instantiateViewController(withIdentifier: sample)
    formatCloseButton(in: controller)
    present(controller, animated: true, completion: nil)
  }
  
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return sampleNames.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "sampleCell")
      as? SamplesTableViewCell else { fatalError() }
    
    if let sampleImage = UIImage(named: sampleNames[indexPath.row]) {
      cell.sampleImage = sampleImage
    }
    return cell
  }
  
  func formatCloseButton(in controller: UIViewController) {
    let closeButton = CloseButton(type: .roundedRect)
    closeButton.addTarget(self, action: #selector(closeController), for: .touchUpInside)
    closeButton.setTitle("Close", for: .normal)
    controller.view.addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    let safeArea = controller.view.safeAreaLayoutGuide
    let top = closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10)
    let trailing = closeButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -10)
    let width = closeButton.widthAnchor.constraint(equalToConstant: 50)
    let height = closeButton.heightAnchor.constraint(equalToConstant: 50)
    NSLayoutConstraint.activate([top, trailing, width, height])
  }
  
  @objc func closeController() {
    dismiss(animated: true, completion: nil)
  }
  
}

