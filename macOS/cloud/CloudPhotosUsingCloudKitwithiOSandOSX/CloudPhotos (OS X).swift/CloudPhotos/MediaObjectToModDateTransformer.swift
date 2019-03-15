/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSValueTransformer subclass for transforming MLMediaObject to it's modification date value.
 */

import Foundation
import MediaLibrary

class MediaObjectToModDateTransformer : ValueTransformer {
    func transformedValueClass() -> AnyClass {
        return CLLocation.self
    }
    
    func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard value != nil else { return nil }
        
        let mediaObject = value as! MLMediaObject
        let returnDate = mediaObject.attributes["modificationDate"]
        return returnDate
    }
}
