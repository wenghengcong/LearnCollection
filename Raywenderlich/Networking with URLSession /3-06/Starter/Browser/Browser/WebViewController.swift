//
//  WebViewController.swift
//  Browser
//
//  Created by Brian on 9/10/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  @IBOutlet weak var webView: WKWebView!
  var url: URL?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      guard let url = url else { return }
      let request = URLRequest(url: url)
      webView.load(request)
    }
    
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
