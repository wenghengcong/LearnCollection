//
//  CollectionViewItem.swift
//  CollectionViewDemo
//
//  Created by WengHengcong on 2019/2/22.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else {
                return
            }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        //未选中
        view.layer?.borderColor = NSColor.red.cgColor
        view.layer?.borderWidth = 0.0
    }
    
    // 点击
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    func setHighlight(selected: Bool) {
        view.layer?.borderWidth = selected ? 5.0 : 0.0
    }
}
