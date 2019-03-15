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

class Result : NSObject {
  dynamic var rank = 0
  dynamic var artistName = ""
  dynamic var trackName = ""
  dynamic var averageUserRating = 0.0
  dynamic var averageUserRatingForCurrentVersion = 0.0
  dynamic var itemDescription = ""
  dynamic var price = 0.00
  dynamic var releaseDate = Date()
  dynamic var artworkURL: URL?
  dynamic var artworkImage: NSImage?
  dynamic var screenShotURLs: [URL] = []
  dynamic var screenShots = NSMutableArray()
  dynamic var userRatingCount = 0
  dynamic var userRatingCountForCurrentVersion = 0
  dynamic var primaryGenre = ""
  dynamic var fileSizeInBytes = 0
  dynamic var cellColor = NSColor.white
  
  init(dictionary: Dictionary<String, AnyObject>) {
    artistName = dictionary["artistName"] as! String
    trackName = dictionary["trackName"] as! String
    itemDescription = dictionary["description"] as! String
    
    primaryGenre = dictionary["primaryGenreName"] as! String
    if let uRatingCount = dictionary["userRatingCount"] as? Int {
      userRatingCount = uRatingCount
    }
    
    if let uRatingCountForCurrentVersion = dictionary["userRatingCountForCurrentVersion"] as? Int {
      userRatingCountForCurrentVersion = uRatingCountForCurrentVersion
    }
    
    if let averageRating = (dictionary["averageUserRating"] as? Double) {
      averageUserRating = averageRating
    }
    
    if let averageRatingForCurrent = dictionary["averageUserRatingForCurrentVersion"] as? Double {
      averageUserRatingForCurrentVersion = averageRatingForCurrent
    }
    
    if let fileSize = dictionary["fileSizeBytes"] as? String {
      if let fileSizeInt = Int(fileSize) {
        fileSizeInBytes = fileSizeInt
      }
    }
    
    if let appPrice = dictionary["price"] as? Double {
      price = appPrice
    }
    
    let formatter = DateFormatter()
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.locale = enUSPosixLocale as Locale!
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    if let releaseDateString = dictionary["releaseDate"] as? String {
      releaseDate = formatter.date(from: releaseDateString)!
    }
    if let artURL = URL(string: dictionary["artworkUrl512"] as! String) {
      artworkURL = artURL
    }
    
    if let screenShotsArray = dictionary["screenshotUrls"] as? [String] {
      for screenShotURLString in screenShotsArray {
        if let screenShotURL = URL(string: screenShotURLString) {
          screenShotURLs.append(screenShotURL)
        }
      }
    }
    
    super.init()
  }
  
  func loadIcon() {
    guard let artworkURL = artworkURL else { return }
    
    if (artworkImage != nil) {
      return
    }
    
    iTunesRequestManager.downloadImage(artworkURL, completionHandler: { (image, error) -> Void in
      DispatchQueue.main.async(execute: {
        self.artworkImage = image
      })
    })
  }
  
  func loadScreenShots() {
    if screenShots.count > 0 {
      return
    }
    
    for screenshotURL in screenShotURLs {
      iTunesRequestManager.downloadImage(screenshotURL, completionHandler: { (image, error) -> Void in
        DispatchQueue.main.async(execute: {
          guard let image = image , error == nil else {
            return;
          }
          
          self.willChangeValue(forKey: "screenShots")
          self.screenShots.add(image)
          self.didChangeValue(forKey: "screenShots")
        })
        
      })
    }
  }
  
  override var description: String {
    get {
      return "artist: \(artistName) track: \(trackName) average rating: \(averageUserRating) price: \(price) release date: \(releaseDate)"
    }
  }
}
