/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A function to handle CloudKit errors.
 */

import UIKit
import CloudKit

// Operation types that identifying what is doing.
//
enum CloudKitOperationType: String {
    case accountStatus = "AccountStatus"// Doing account check with CKContainer.accountStatus.
    case fetchRecords = "FetchRecords"  // Fetching data from the CloudKit server.
    case modifyRecords = "ModifyRecords"// Modifying records (.serverRecordChanged should be handled).
    case deleteRecords = "DeleteRecords"// Deleting records.
    case modifyZones = "ModifyZones"    // Modifying zones (.serverRecordChanged should be handled).
    case deleteZones = "DeleteZones"    // Deleting zones.
    case fetchZones = "FetchZones"      // Fetching zones.
    case modifySubscriptions = "ModifySubscriptions"    // Modifying subscriptions.
    case deleteSubscriptions = "DeleteSubscriptions"    // Deleting subscriptions.
    case fetchChanges = "FetchChanges"  // Fetching changes (.changeTokenExpired should be handled).
    case acceptShare = "AcceptShare"    // Doing CKAcceptSharesOperation.
}

// Return nil: no error or the error is ignorable.
// Return a CKError: there is an error; calls should determine how to handle it.
//
func handleCloudKitError(_ error: Error?, operation: CloudKitOperationType,
                         affectedObjects: [Any]? = nil, alert: Bool = false) -> CKError? {
    
    // nsError == nil: Everything goes well, callers can continue.
    //
    guard let nsError = error as NSError? else { return nil }
    
    // Partial errors can happen when fetching or changing the database.
    //
    // When modifying zones, records, and subscription,.serverRecordChanged may happen if
    // the other peer changed the item at the same time. In that case, retrieve the first
    // CKError object and return to callers.
    //
    // In the case of .fetchRecords and fetchChanges, the specified items or zone may just
    // be deleted by the other peer and don't exist in the database (.unknownItem or .zoneNotFound).
    //
    if let partialError = nsError.userInfo[CKPartialErrorsByItemIDKey] as? NSDictionary {
        
        let errors = affectedObjects?.map({ partialError[$0] }).filter({ $0 != nil })
        
        // If the error doesn't affect the affectedObjects, ignore it.
        // Only handle the first error.
        //
        guard let ckError = errors?.first as? CKError else { return nil }
        
        // Items not found. Sliently ignore for the delete operation.
        //
        if operation == .deleteZones || operation == .deleteRecords || operation == .deleteSubscriptions {
            if ckError.code == .unknownItem {
                return nil
            }
        }
        
        if ckError.code == .serverRecordChanged {
            print("Server record changed. Consider using serverRecord and ignore this error!")
        } else if ckError.code == .zoneNotFound {
            print("Zone not found. May have been deleted. Probably ignore!")
        } else if ckError.code == .unknownItem {
            print("Unknow item. May have been deleted. Probably ignore!")
        } else if ckError.code == .batchRequestFailed {
            print("Atomic failure!")
        } else {
            if alert {
                presentAlert(operation: operation, error: nsError)
            }
            print("!!!!!\(operation.rawValue) operation error: \(nsError)")
        }
        return ckError
    }
    
    // In the case of fetching changes:
    // .changeTokenExpired: return for callers to refetch with nil server token.
    // .zoneNotFound: return for callers to switch zone, as the current zone has been deleted.
    // .partialFailure: zoneNotFound will trigger a partial error as well.
    //
    if operation == .fetchChanges {
        if let ckError = error as? CKError {
            if ckError.code == .changeTokenExpired || ckError.code == .zoneNotFound {
                return ckError
            }
        }
    }
    
    // If the client wants an alert, alert the error, or append the error message to an existing alert.
    //
    if alert {
        presentAlert(operation: operation, error: nsError)
    }
    print("!!!!!\(operation.rawValue) operation error: \(nsError)")
    return error as? CKError
}

private func presentAlert(operation: CloudKitOperationType, error: NSError) {
    
    DispatchQueue.main.async {
        guard let window = UIApplication.shared.delegate?.window,
            let viewController = window?.rootViewController else { return }
        
        let message = "\(operation.rawValue) operation hit this error:\n\(error)"
        
        if let currentAlert = viewController.presentedViewController as? UIAlertController {
            currentAlert.message = (currentAlert.message ?? "") + "\n\n\(message)"
            return
        }
        
        let alert = UIAlertController(title: "CloudKit Operation Error!",
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController.present(alert, animated: true)
    }
}
