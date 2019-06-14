//
//  FlickrTableViewController.swift
//  FlickrImages
//
//  Created by Brian on 8/21/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

struct FlickerJSON: Codable {
  struct FlickrItem: Codable {
    let media: Dictionary<String, String>
    let title: String
  }
  let items: [FlickrItem]
}

struct FlckrPhoto {
  let image: UIImage
  let title: String
}

class FlickrTableViewController: UITableViewController {

    var photos: [FlckrPhoto] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()
      loadFlickrImage()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return photos.count
    }

    func loadFlickrImage() {
      
      // Create a configuration
      
      // Create a session
      
      // Setup the url
      let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
      
      // Create the task

//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
//          return
//        }
//        do {
//          let decoder = JSONDecoder()
//          let media = try decoder.decode(FlickerJSON.self, from: data)
//          for item in media.items {
//            if let imageURL = item.media["m"] {
//              let url = URL(string: imageURL)!
//              let imageData = try Data(contentsOf: url)
//              if let image = UIImage(data: imageData) {
//                let flickrImage = FlckrPhoto(image: image, title: item.title)
//                self.photos.append(flickrImage)
//              }
//            }
//          }
//          let queue = OperationQueue.main
//          queue.addOperation {
//            self.tableView.reloadData()
//          }
//        } catch {
//          print("Error info: \(error)")
//        }
//      }
  
      
      
      
    }
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath)

        cell.imageView?.image = photos[indexPath.row].image
        cell.textLabel?.text = photos[indexPath.row].title

        return cell
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PhotoSegue" {
      guard let cell = sender as? UITableViewCell, let photoViewController = segue.destination as? PhotoViewController,  let indexPath = tableView.indexPath(for: cell) else {
        return
      }
      let flickrPhoto = photos[indexPath.row]
      photoViewController.photo = flickrPhoto.image
    
    }
  }

}
