/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
View controller that shows the location of a photo in a popover.
*/

import Cocoa
import Foundation

class WindowController : NSWindowController, NSWindowRestoration {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // We handle the window restoration (so restore0WindowWithIdentifier can be called).
        // Note: The "restorable" and "identifier" properties are setup in IB.
        //
        window!.restorationClass = WindowController.self
    }
    
    /// Sent to request that this window be restored.
    static func restoreWindow(withIdentifier identifier: String, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Swift.Void) {
        var restoreWindow: NSWindow? = nil
        if identifier == "CloudPhotosID" {  // This is the identifier for our NSWindow.
        
            // We didn't create the window, it was created from the storyboard.
            restoreWindow = NSApplication.shared().windows[0]
        }
        completionHandler(restoreWindow, nil)
    }
}
