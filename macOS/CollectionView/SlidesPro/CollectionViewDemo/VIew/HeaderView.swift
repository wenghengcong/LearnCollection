//
//  HeaderView.swift
//  CollectionViewDemo
//
//  Created by WengHengcong on 2019/2/22.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Cocoa

class HeaderView: NSView {

    // 1
    @IBOutlet weak var sectionTitle: NSTextField!
    @IBOutlet weak var imageCount: NSTextField!
    
    // 2
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor(calibratedWhite: 0.8 , alpha: 0.8).set()
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)

    }
}
