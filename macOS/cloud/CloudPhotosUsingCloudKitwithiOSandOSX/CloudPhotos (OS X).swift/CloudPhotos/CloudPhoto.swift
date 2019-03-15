/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Object to describe a photo in this app: a wrapper for CKRecord and useful for Cocoa Bindings.
*/

import Foundation
import CloudKit

class CloudPhoto : NSObject {
    var cloudRecord : CKRecord

    var isMyPhoto : Bool = false
    var distanceFromUser : Double = -1  // in kilometers

    init(record : CKRecord) {
        cloudRecord = record
        
        // Used for Cocoa bindings, when the filterPredicate of the array controller filters by "Mine".
        isMyPhoto = (CloudManager.isMyRecord(cloudRecord.creatorUserRecordID))
        
        super.init()
    }
    
    class func keyPathsForValuesAffectingIsPhotoNearMe() -> Set<String> {
        // "isPhotoNearMe" key path depends on "distanceFromUser" for it's value
        return NSSet(objects:"distanceFromUser") as! Set<String>
    }
    
    /**
    Used for Cocoa bindings, when the filterPredicate of the array controller filters by "Near Me"
    returns true if the given photo is within kNearMeDistance or the user's current location.
    */
    var isPhotoNearMe : Bool {
        get {
            // return yes if the distance is within kNearMeDistance of the user
            return distanceFromUser < kNearMeDistance && distanceFromUser != -1
        }
    }
    
    /// Used for Cocoa bindings, when the filterPredicate of the array controller filters by "Recent".
    var isRecentPhoto : Bool {
        get {
            let calendar: Calendar = Calendar.current
            
            let date1 = Date()
            let date2 = calendar.startOfDay(for: photoDate!)
            let components = calendar.dateComponents([Calendar.Component.day], from: date2, to: date1)
            
            return components.day! <= 5  // recent within last 5 days
        }
    }
    
    // TITLE
    /// Returns the name or title of this CloudPhoto object.
    var photoTitle : String {
        get {
            return cloudRecord[APLCloudManager.photoTitleAttribute()] as! String
        }
        set(title) {
            cloudRecord[APLCloudManager.photoTitleAttribute()] = title as CKRecordValue
        }
    }

    // DATE
    /// Returns the date when this CloudPhoto object was created. (optional as some photos may not have a mod date)
    var photoDate : Date? {
        get {
            return cloudRecord[APLCloudManager.photoDateAttribute()] as? Date
        }
        set(date) {
            cloudRecord[APLCloudManager.photoDateAttribute()] = date as? CKRecordValue
        }
    }
    
    // LOCATION
    /// Returns the CLLocation (geo tagged location) of this CloudPhoto object. (optional as some photos may not have a location)
    var photoLocation : CLLocation? {
        get {
            return cloudRecord[APLCloudManager.photoLocationAttribute()] as? CLLocation
        }
        set(location) {
            cloudRecord[APLCloudManager.photoLocationAttribute()] = location as? CKRecordValue
        }
    }
    
    func record() -> CKRecord {
        return cloudRecord
    }

    // IMAGE
    /// Returns the NSImage of this CloudPhoto object.
    var photoImage : NSImage? {
        get {
            guard let photoAsset = cloudRecord[APLCloudManager.photoAssetAttribute()] as? CKAsset,
                photoAsset.fileURL.path.characters.count > 0 else { return nil }
            
            let imageData = NSImage(contentsOfFile: photoAsset.fileURL.path)!
            return imageData
        }
        set {
            cloudRecord[APLCloudManager.photoAssetAttribute()] = nil
        }
    }
    
    func setPhotoImageURL(_ imageURL: URL) {
        let asset = CKAsset(fileURL:imageURL)
        cloudRecord[APLCloudManager.photoAssetAttribute()] = asset
    }

    // OWNER
    /**
    Returns the owner of this CloudPhoto object; asynchronously fetches the owner of a given photo,
    and uses the completion handler to return it back.
    */
    func photoOwner(_ completionHandler: @escaping (String?) -> Void) {
        CloudManager.fetchUserName(from: cloudRecord.creatorUserRecordID) { (familyName) in
            completionHandler(familyName)
        }
    }
}
