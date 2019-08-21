/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSValueTransformer subclass for transforming MLMediaObject to it's CLLocation value.
 */

import Foundation
import MediaLibrary

class MediaObjectToLocationTransformer : ValueTransformer {
    func transformedValueClass() -> AnyClass {
        return CLLocation.self
    }
    
    func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard value != nil else { return nil }
        
        let mediaObject = value as! MLMediaObject
        
        // Convert the latitude/longitude values from the media object to a CLLocation object.
        var returnLocation : CLLocation?
        if let latitude = mediaObject.attributes["latitude"] {
            if let longitude = mediaObject.attributes["longitude"] {
                returnLocation = CLLocation(latitude: (latitude as! NSNumber).doubleValue, longitude: (longitude as! NSNumber).doubleValue)
            }
        }
            
        return returnLocation
    }
}
