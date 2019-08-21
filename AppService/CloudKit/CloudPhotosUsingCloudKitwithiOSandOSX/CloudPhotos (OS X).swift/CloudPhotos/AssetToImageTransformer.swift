/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Value transformer to change a CKAsset to an image.
*/

import Foundation

// We use this value transformer to help us bind our table cell view's image to the CKAsset image.
//
class AssetToImageTransformer : ValueTransformer {
    func transformedValueClass() -> AnyClass {
        return NSImage.self
    }
    
    func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        // Update the photo.
        if value != nil {
            let photo = value as! CloudPhoto
            let imageData = photo.photoImage
            
            return imageData
        }
        return nil
    }
}
