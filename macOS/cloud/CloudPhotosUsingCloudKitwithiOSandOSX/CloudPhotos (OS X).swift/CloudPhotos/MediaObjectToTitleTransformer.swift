/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSValueTransformer subclass for transforming MLMediaObject to it's name value.
 */

import Foundation
import MediaLibrary

class MediaObjectToTitleTransformer : ValueTransformer {
    func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        var title = String()
        
        guard value != nil else { return nil }
        
        let mediaObject = value as! MLMediaObject

        guard mediaObject.attributes["name"] != nil else {
            
            let url = mediaObject.url!
            
            // This URL might point outside the Pictures folder, so security scope it.
            if url.startAccessingSecurityScopedResource() {
                
                var imageTitleToUse : AnyObject?
                
                try! (url as NSURL).getPromisedItemResourceValue(&imageTitleToUse, forKey: URLResourceKey.localizedNameKey)
                url.stopAccessingSecurityScopedResource()
                
                title = imageTitleToUse as! String
            }
            return title
        }
        
        title = mediaObject.attributes["name"] as! String
        return title
    }
}
