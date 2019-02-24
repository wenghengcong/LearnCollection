/*
 * ViewController.swift
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

class ViewController: NSViewController {
  
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var addSlideButton: NSButton!
  @IBOutlet weak var removeSlideButton: NSButton!
  
  let imageDirectoryLoader = ImageDirectoryLoader()
  var indexPathsOfItemsBeingDragged: Set<IndexPath>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let initialFolderUrl = NSURL.fileURL(withPath: "/Library/Desktop Pictures", isDirectory: true)
    imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
    configureCollectionView()
    registerForDragAndDrop()
  }
  
  func registerForDragAndDrop() {
    // 1
    if #available(OSX 10.13, *) {
      collectionView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
    } else {
      // Fallback on earlier versions
    }
    // 2
    collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
    // 3
    collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
  }

  func loadDataForNewFolderWithUrl(folderURL: URL) {
    imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
    collectionView.reloadData()
  }

  private func configureCollectionView() {
    let flowLayout = StickyHeadersLayout()
    flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
    flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20, bottom: 10.0, right: 20.0)
    flowLayout.minimumInteritemSpacing = 20.0
    flowLayout.minimumLineSpacing = 20.0
    collectionView.collectionViewLayout = flowLayout
    view.wantsLayer = true
    collectionView.layer?.backgroundColor = NSColor.white.cgColor
  }
  
  @IBAction func showHideSections(sender: AnyObject) {
    let show = (sender as! NSButton).state
    imageDirectoryLoader.singleSectionMode = (show == .off)
    imageDirectoryLoader.setupDataForUrls(nil)
    collectionView.reloadData()
  }

  func highlightItems(selected: Bool, atIndexPaths: Set<IndexPath>) {
    for indexPath in atIndexPaths {
      guard let item = collectionView.item(at: indexPath) else {continue}
      (item as! CollectionViewItem).setHighlight(selected: selected)
    }
    addSlideButton.isEnabled = collectionView.selectionIndexPaths.count == 1
    removeSlideButton.isEnabled = !collectionView.selectionIndexPaths.isEmpty
  }
  
  @IBAction func addSlide(sender: NSButton) {
    // 1
    let insertAtIndexPath = collectionView.selectionIndexPaths.first!
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    openPanel.allowsMultipleSelection = true;
    openPanel.allowedFileTypes = ["public.image"]
    openPanel.beginSheetModal(for: self.view.window!) { (response) -> Void in
      guard response.rawValue == NSFileHandlingPanelOKButton else {return}
      self.insertAtIndexPathFromURLs(urls: openPanel.urls, atIndexPath: insertAtIndexPath)
    }
  }
  
  private func insertAtIndexPathFromURLs (urls: [URL], atIndexPath: IndexPath) {
    var indexPaths: Set<IndexPath> = []
    let section = atIndexPath.section
    var currentItem = atIndexPath.item
    
    // 2
    for url in urls {
      // 3
      let imageFile = ImageFile(url: url)
      let currentIndexPath = IndexPath(item: currentItem, section: section)
      imageDirectoryLoader.insertImage(image: imageFile!, atIndexPath: currentIndexPath)
      indexPaths.insert(currentIndexPath)
      currentItem += 1
    }
    
    // 4
    NSAnimationContext.current.duration = 1.0;
    collectionView.animator().insertItems(at: indexPaths)
  }

  @IBAction func removeSlide(sender: NSButton) {
    
    let selectionIndexPaths = collectionView.selectionIndexPaths
    if selectionIndexPaths.isEmpty {
      return
    }
    
    // 1
    var selectionArray = Array(selectionIndexPaths)
    selectionArray.sort { (path1, path2) -> Bool in
      return path1.compare(path2) == ComparisonResult.orderedDescending
    }
    for itemIndexPath in selectionArray {
      // 2
      imageDirectoryLoader.removeImageAtIndexPath(indexPath: itemIndexPath)
    }
    
    // 3
    NSAnimationContext.current.duration = 1.0;
    collectionView.animator().deleteItems(at: selectionIndexPaths)  }
}

// MARK: - NSCollectionViewDataSource
extension ViewController : NSCollectionViewDataSource {
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return imageDirectoryLoader.numberOfSections
  }
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageDirectoryLoader.numberOfItemsInSection(section: section)
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
    guard let collectionViewItem = item as? CollectionViewItem else {return item}
    
    let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath)
    collectionViewItem.imageFile = imageFile
    
    let isItemSelected = collectionView.selectionIndexPaths.contains(indexPath as IndexPath)
    collectionViewItem.setHighlight(selected: isItemSelected)
    
    return item
  }
  
  func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
    // 1
    let identifier: String = kind == NSCollectionView.elementKindSectionHeader ? "HeaderView" : ""
    let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), for: indexPath)
    // 2
    if (kind == NSCollectionView.elementKindSectionHeader) {
      let headerView = view as! HeaderView
      headerView.sectionTitle.stringValue = "Section \(indexPath.section)"
      let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(section: indexPath.section)
      headerView.imageCount.stringValue = "\(numberOfItemsInSection) image files"
    }
    return view
  }
  
}

// MARK: - NSCollectionViewDelegateFlowLayout
extension ViewController : NSCollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
    return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
  }
}

// MARK: - NSCollectionViewDelegate
extension ViewController : NSCollectionViewDelegate {
  
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    highlightItems(selected: true, atIndexPaths: indexPaths)
  }

  
  func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
    highlightItems(selected: false, atIndexPaths: indexPaths)
  }
  
  // 1
  func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
    return true
  }
  
  // 2
  func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
    let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath: indexPath)
    return imageFile.url.absoluteURL as! NSPasteboardWriting
  }

  // 1
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
    indexPathsOfItemsBeingDragged = indexPaths
  }
  
  func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
    
    if proposedDropOperation.pointee == NSCollectionView.DropOperation.on {
      proposedDropOperation.pointee = NSCollectionView.DropOperation.before
    }
    if indexPathsOfItemsBeingDragged == nil {
      return NSDragOperation.copy
    } else {
      let sectionOfItembeingDragged = indexPathsOfItemsBeingDragged.first!.section
      // 1
      let proposedDropsection = proposedDropIndexPath.pointee.section
      if sectionOfItembeingDragged == proposedDropsection && indexPathsOfItemsBeingDragged.count == 1 {
        return NSDragOperation.move
      } else {
        // 2
        return NSDragOperation.private
      }
    }
  }
  
  // 1
  func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
    if indexPathsOfItemsBeingDragged != nil {
      // 2
      let indexPathOfFirstItembeingDragged = indexPathsOfItemsBeingDragged.first!
      var toIndexPath: IndexPath
      if indexPathOfFirstItembeingDragged.compare(indexPath as IndexPath) == .orderedAscending {
        toIndexPath = IndexPath(item: indexPath.item-1, section: indexPath.section)
      } else {
        toIndexPath = IndexPath(item: indexPath.item, section: indexPath.section)
      }
      // 3
      imageDirectoryLoader.moveImageFromIndexPath(indexPath: indexPathOfFirstItembeingDragged, toIndexPath: toIndexPath)
      // 4
      NSAnimationContext.current.duration = 1.0;
      collectionView.animator().moveItem(at: indexPathOfFirstItembeingDragged as IndexPath, to: toIndexPath as IndexPath)
    } else {
      // 5
      var droppedObjects = Array<URL>()
      draggingInfo.enumerateDraggingItems(options: NSDraggingItemEnumerationOptions.concurrent, for: collectionView, classes: [NSURL.self], searchOptions: [NSPasteboard.ReadingOptionKey.urlReadingFileURLsOnly: NSNumber(booleanLiteral: true)]) { (draggingItem, idx, stop) in
          if let url = draggingItem.item as? NSURL {
            droppedObjects.append(url as URL)
          }
      }
      // 6
      insertAtIndexPathFromURLs(urls: droppedObjects, atIndexPath: indexPath)
    }
    return true
  }
  
  // 7
  func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
    indexPathsOfItemsBeingDragged = nil
  }


}

