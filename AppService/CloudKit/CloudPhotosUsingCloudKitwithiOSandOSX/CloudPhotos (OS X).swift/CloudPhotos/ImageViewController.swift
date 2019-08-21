/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
View controller that shows the photo in a popover.
*/

import Cocoa
import Foundation

class ImageViewController : NSViewController {
    // MARK: - Properties
    
    var image: NSImage!
    @IBOutlet private weak var imageView: NSImageView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard image != nil else { return }

        imageView.image = image
    }
}
