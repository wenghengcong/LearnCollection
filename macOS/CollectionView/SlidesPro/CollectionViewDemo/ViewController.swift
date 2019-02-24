//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by WengHengcong on 2019/2/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    let imageDirectoryLoader = ImageDirectoryLoader()

    @IBAction func showHideSections(_ sender: Any) {
        // 2
        let show = (sender as! NSButton).state
        imageDirectoryLoader.singleSectionMode = (show == .off)
        imageDirectoryLoader.setupDataForUrls(nil)
        // 3
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialFolderUrl = URL(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
        configureCollection()
    }
    
    func configureCollection() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160, height: 140)
        flowLayout.sectionInset = NSEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.sectionHeadersPinToVisibleBounds = true

        collectionView.collectionViewLayout = flowLayout
        flowLayout.sectionHeadersPinToVisibleBounds = true

        // for optimal performance, NSCollectionView is designed to be layer-backed. So, you’re setting an ancestor’s wantsLayer property to true.
        view.wantsLayer = true
        
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension ViewController : NSCollectionViewDataSource {
    // 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return imageDirectoryLoader.numberOfSections
    }

    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItemsInSection(section)
    }
    
    // 3
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        // 5
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        collectionViewItem.imageFile = imageFile
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        // 1
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as! HeaderView
        // 2
        view.sectionTitle.stringValue = "Section \(indexPath.section)"
        let numberOfItemsInSection = imageDirectoryLoader.numberOfItemsInSection(indexPath.section)
        view.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        return view
    }
    
}
//点击事件
extension ViewController : NSCollectionViewDelegate {
    // 1
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        // 2
        guard let indexPath = indexPaths.first else {
            return
        }
        // 3
        guard let item = collectionView.item(at: indexPath as IndexPath) else {
            return
        }
        (item as! CollectionViewItem).setHighlight(selected: true)
    }
    private func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
  
    }
    // 4
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            return
        }
        guard let item = collectionView.item(at: indexPath as IndexPath) else {
            return
        }
        (item as! CollectionViewItem).setHighlight(selected: false)
    }
}

// 头部的大小
extension ViewController : NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return imageDirectoryLoader.singleSectionMode ? NSZeroSize : NSSize(width: 1000, height: 40)
    }
}

