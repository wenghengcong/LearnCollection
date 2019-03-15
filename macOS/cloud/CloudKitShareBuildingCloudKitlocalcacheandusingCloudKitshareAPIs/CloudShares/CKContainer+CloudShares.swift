/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Extension of CKContainer, implementing some convenient methods related to sharing.
 */

import UIKit
import CloudKit

extension CKContainer {
    
    // Fetch participants from the container and add them if the share is private.
    // If a participant with a matching userIdentity already exists in this share,
    // the existing participant’s properties are updated and no new participant is added.
    // Note that private users cannot be added to a public share.
    //
    private func addParticipants(
        to share: CKShare, lookupInfos: [CKUserIdentityLookupInfo], operationQueue: OperationQueue) {
        
        if !lookupInfos.isEmpty && share.publicPermission == .none {
            
            let fetchParticipantsOp = CKFetchShareParticipantsOperation(userIdentityLookupInfos: lookupInfos)
            fetchParticipantsOp.shareParticipantFetchedBlock = { participant in
                share.addParticipant(participant)
            }
            fetchParticipantsOp.fetchShareParticipantsCompletionBlock = { error in
                guard handleCloudKitError(error, operation: .fetchRecords) == nil else { return }

            }
            fetchParticipantsOp.container = self
            operationQueue.addOperation(fetchParticipantsOp)
        }
    }
    
    // Set up UICloudSharingController for a root record. This is synchronous and can be called
    // from any queue. Completionhandler is called from the same queue where prepareSharingController is called
    //
    func prepareSharingController( rootRecord: CKRecord, participantLookupInfos: [CKUserIdentityLookupInfo]? = nil,
                                   database: CKDatabase, zone: CKRecordZone,
                                   completionHandler:@escaping (UICloudSharingController?) -> Void) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        // Share setup: fetch the share if the root record has been shared, or create a new one.
        //
        var sharingController: UICloudSharingController? = nil
        var share: CKShare! = nil
        
        if let shareRef = rootRecord.share {
            // Fetch CKShare record if the root record has alreaad shared.
            //
            let fetchRecordsOp = CKFetchRecordsOperation(recordIDs: [shareRef.recordID])
            fetchRecordsOp.fetchRecordsCompletionBlock = {recordsByRecordID, error in
                
                guard handleCloudKitError(error, operation: .fetchRecords, affectedObjects: [shareRef.recordID]) == nil,
                    let result = recordsByRecordID?[shareRef.recordID] as? CKShare else { return }

                share = result
                
                if let lookupInfos = participantLookupInfos {
                    self.addParticipants(to: share, lookupInfos: lookupInfos, operationQueue: operationQueue)
                }
            }
            fetchRecordsOp.database = database
            operationQueue.addOperation(fetchRecordsOp)
            
            // Wait until all operation are finished.
            // If share is still nil when all operations done, then there are errors.
            //
            operationQueue.waitUntilAllOperationsAreFinished()
            
            if let share = share {
                sharingController = UICloudSharingController(share: share, container: self)
            }
            
        } else {
            
            sharingController = UICloudSharingController { (_, prepareCompletionHandler) in
                
                let shareID = CKRecordID(recordName: UUID().uuidString, zoneID: zone.zoneID)
                share = CKShare(rootRecord: rootRecord, shareID: shareID)
                share[CKShareTitleKey] = "A cool topic to share!" as CKRecordValue
                share.publicPermission = .none // default value.
                
                // addParticipants is asynchronous, but will be executed before modifyRecordsOp because
                // the operationqueue is serial.
                //
                if let lookupInfos = participantLookupInfos {
                    self.addParticipants(to: share, lookupInfos: lookupInfos, operationQueue: operationQueue)
                }
                
                // Clear the parent property because root record is now sharing independently.
                // Restore it when the sharing is stoped if necessary (cloudSharingControllerDidStopSharing).
                //
                rootRecord.parent = nil
                
                let modifyRecordsOp = CKModifyRecordsOperation(recordsToSave: [share, rootRecord], recordIDsToDelete: nil)
                modifyRecordsOp.modifyRecordsCompletionBlock = { records, recordIDs, error in
                    
                    // Use the serverRecord when a partial failure caused by .serverRecordChanged occurs.
                    // Let UICloudSharingController handle the other error, until failedToSaveShareWithError is called.
                    //
                    if let ckError = handleCloudKitError(error, operation: .modifyRecords, affectedObjects: [shareID]) {
                        if let serverVersion = ckError.serverRecord as? CKShare {
                            share = serverVersion
                        }
                    }
                    prepareCompletionHandler(share, self, error)
                }
                modifyRecordsOp.database = database
                operationQueue.addOperation(modifyRecordsOp)
            }
        }
        completionHandler(sharingController)
    }
}

