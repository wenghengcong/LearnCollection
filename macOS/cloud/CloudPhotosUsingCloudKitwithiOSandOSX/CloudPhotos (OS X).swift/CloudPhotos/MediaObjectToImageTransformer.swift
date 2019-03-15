/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSValueTransformer subclass for transforming MLMediaObject to it's NSImage value.
 */

import Foundation
import MediaLibrary

class MediaObjectToImageTransformer : ValueTransformer {
    func transformedValueClass() -> AnyClass {
        return NSImage.self
    }
    
    func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard value != nil else { return nil }
        
        let mediaObject = value as! MLMediaObject
        let imageData = NSImage(contentsOf: mediaObject.thumbnailURL!)
        return imageData
    }
}
