/*
* Copyright (c) 2015 Razeware LLC
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

// http://www.materialpalette.com/light-blue/deep-orange

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var avatarView: AvatarView!
  @IBOutlet weak var followButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let books = Book.all
 
  override func viewDidLoad() {
    super.viewDidLoad()
    followButton.layer.cornerRadius = (followButton.bounds.height)/2.0
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? NSIndexPath else {
            return
        }
        let destinationViewController = segue.destination as! BookViewController
        destinationViewController.book = books[indexPath.row]
    }

  
  @IBAction func unwindToProfileView(sender: UIStoryboardSegue) {
  }
  
}

// MARK: - UICollectionView Data Source
extension ProfileViewController: UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        
        let book = books[indexPath.row]
        cell.imageView.image = book.cover
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let _ = self.collectionView(collectionView, cellForItemAt: indexPath) as? BookCell {
            performSegue(withIdentifier: "ShowBook", sender: indexPath)
        }
    }
}

// MARK: - UICollectionView Delegate Flow Layout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
  
  // Resize books collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let book = books[indexPath.row]
        guard book.cover.size.height > 0 else {
            return collectionView.bounds.size
        }
        
        // calculate cell size based on image height and collection view height
        let ratio = (collectionView.bounds.height) / book.cover.size.height
        let margin:CGFloat = 5.0
        let size = CGSize(width: book.cover.size.width * ratio + margin, height: book.cover.size.height * ratio)
        return size
    }
}



