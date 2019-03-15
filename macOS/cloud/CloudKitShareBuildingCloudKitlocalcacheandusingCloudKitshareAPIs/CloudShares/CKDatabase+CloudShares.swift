/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Extensions of CKDatabase, implementing some reusable and convenient code.
 */

import UIKit
import CloudKit

extension CKDatabase {
    
    var name: String { // Provide a display name for the database.
        switch databaseScope {
        case .public: return "Public"
        case .private: return "Private"
        case .shared: return "Shared"
        }
    }
    
    // Add operation to the specified operation queue, or the database internal queue if
    // there is no operation queue specified.
    //
    private func add(_ operation: CKDatabaseOperation, to queue: OperationQueue?) {
        
        if let operationQueue = queue {
            operation.database = self
            operationQueue.addOperation(operation)
            
        } else {
            add(operation)
        }
    }
        
    // Use subscriptionID to create a subscriotion. Expect to hit an error of the subscritopn with the same ID
    // already exists.
    //
    func addDatabaseSubscription(
        subscriptionID: String, operationQueue: OperationQueue? = nil,
        completionHandler: @escaping (NSError?) -> Void) {
        
        let subscription = CKDatabaseSubscription(subscriptionID: subscriptionID)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldBadge = true
        notificationInfo.alertBody = "Database (\(subscriptionID)) was changed!"
        
        subscription.notificationInfo = notificationInfo
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: nil)
        
        operation.modifySubscriptionsCompletionBlock = { _, _, error in
            completionHandler(error as NSError?)
        }
        
        add(operation, to: operationQueue)
    }
}
