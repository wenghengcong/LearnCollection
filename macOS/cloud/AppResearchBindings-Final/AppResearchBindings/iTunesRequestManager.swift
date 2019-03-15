/**
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

struct iTunesRequestManager {
  static func getSearchResults(_ query: String, results: Int, langString :String, completionHandler: @escaping ([[String : AnyObject]], NSError?) -> Void) {
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
    let termQueryItem = URLQueryItem(name: "term", value: query)
    let limitQueryItem = URLQueryItem(name: "limit", value: "\(results)")
    let mediaQueryItem = URLQueryItem(name: "media", value: "software")
    urlComponents?.queryItems = [termQueryItem, mediaQueryItem, limitQueryItem]
    
    guard let url = urlComponents?.url else {
      return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
      guard let data = data else {
        completionHandler([], nil)
        return
      }
      do {
        guard let itunesData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] else {
          completionHandler([], nil)
          return
        }
        if let results = itunesData["results"] as? [[String : AnyObject]] {
          completionHandler(results, nil)
        } else {
          completionHandler([], nil)
        }
      } catch _ {
        completionHandler([], error as NSError?)
      }
      
    })
    task.resume()
  }
  
  static func downloadImage(_ imageURL: URL, completionHandler: @escaping (NSImage?, NSError?) -> Void) {
    let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
      guard let data = data , error == nil else {
        completionHandler(nil, error as NSError?)
        return
      }
      let image = NSImage(data: data)
      completionHandler(image, nil)
    })
    task.resume()
  }
}
