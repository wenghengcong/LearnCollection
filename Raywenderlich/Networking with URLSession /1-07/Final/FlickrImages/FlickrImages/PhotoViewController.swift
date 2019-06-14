//
//  PhotoViewController.swift
//  FlickrImages
//
//  Created by Brian on 8/21/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

  @IBOutlet weak var photoImageView: UIImageView!
  var photo: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    photoImageView.image = photo
  }
}
