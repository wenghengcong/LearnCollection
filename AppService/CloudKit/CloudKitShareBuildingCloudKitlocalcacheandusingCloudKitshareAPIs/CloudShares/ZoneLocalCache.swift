/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Zone local cache class, managing the zone local cache.
 */

import Foundation
import CloudKit

// "container" and "database" are immutalbe; "zones" and "serverChangeToken" in Database is mutable.
// ZoneLocalCache follows these rules to be thread-safe:
// 1. Public methods access to "zones" and "serverChangeToken" in Database via "perform...".
// 2. Private methods that access mutable properties should be called via "perform...".
// 3. Private methods access mutable properties directly because of #2
// 4. Immutable properties are accessed directly.
//
// We don't provide accessors to protect mutable properties because we don't want to call "perform..."
// in every call to the properties. Clients should wrap the code accessing mutable properties
// directly with "perform...".
//
// Clients follow these rules to thread-safely use BaseLocalCache or its subclasses:
// 1. Access mutable properties via "perform...".
// 2. Call public methods directly, otherwise will trigger a deadlock
//
final class ZoneLocalCache: BaseLocalCache {
    
    let container: CKContainer
    let databases: [Database]
    
    // Subscribe the database changes and do the first fetch from server to build up the cache.
    //
    // We use CKDatabaseSubscription to sync the changes on sharedDB and custom zones of privateDB
    // CKDatabaseSubscription currently doesn't work for the default zone.
    // CKRecordZoneSubscription doesn't support the default zone and sharedDB,
    // CKQuerySubscription doesn't support shardDB.
    //
    init(_ container: CKContainer) {
        
        self.container = container
        databases = [Database(cloudKitDB: container.privateCloudDatabase),
                     Database(cloudKitDB: container.sharedCloudDatabase)]
        super.init()

        for database in databases {
            
            database.cloudKitDB.addDatabaseSubscription(subscriptionID: database.cloudKitDB.name,
                                                        operationQueue: operationQueue) { error in
                guard handleCloudKitError(error, operation: .modifySubscriptions, alert: true) == nil else { return }
                self.fetchChanges(from: database)
            }
        }
    }
    
    // Update the cache by fetching the database changes.
    //
    func fetchChanges(from database: Database) {
        
        // notificationObject should be class semantic because it'll be changed later.
        //
        var zoneIDsChanged = [CKRecordZoneID](), zoneIDsDeleted = [CKRecordZoneID]()
        let notificationObject = ZoneCacheDidChange()

        let serverChangeToken = performReaderBlockAndWait { return database.serverChangeToken }
        let operation = CKFetchDatabaseChangesOperation(previousServerChangeToken: serverChangeToken)
        
        operation.changeTokenUpdatedBlock = { serverChangeToken in
            self.performWriterBlock { database.serverChangeToken = serverChangeToken }
        }
        
        operation.recordZoneWithIDWasDeletedBlock = { zoneID in // Callback for zones that were deleted.
            self.performWriterBlock {
                if let index = database.zones.index(where: { $0.zoneID == zoneID }) {
                    database.zones.remove(at: index)
                }
            }
            zoneIDsDeleted.append(zoneID)
        }
        
        operation.recordZoneWithIDChangedBlock = { zoneID in // Gather the changed zone IDs.
            zoneIDsChanged.append(zoneID)
        }
        
        // Updated the cache when fetching changes completed.
        //
        operation.fetchDatabaseChangesCompletionBlock = { serverChangeToken, moreComing, error in
            
            if let ckError = handleCloudKitError(error, operation: .fetchChanges, alert: true),
                ckError.code == .changeTokenExpired {
                
                self.performWriterBlock { database.serverChangeToken = nil }
                self.fetchChanges(from: database) // Fetch changes again with nil token.
                return
            }

            self.performWriterBlock { database.serverChangeToken = serverChangeToken }
            
            guard moreComing == false else { return }
            
            // The IDs in zoneIDsChanged can be in zoneIDsDeleted, meaning a changed zone can be
            // deleted, so filter out the updated but deleted zoneIDs.
            //
            zoneIDsChanged = zoneIDsChanged.filter { zoneID in return !zoneIDsDeleted.contains(zoneID) }
            
            // Set database, recordIDsDeleted and recordsChanged into notification payload.
            //
            notificationObject.payload = ZoneCacheChanges(
                database: database, zoneIDsDeleted: zoneIDsDeleted, zoneIDsChanged: zoneIDsChanged)
            
            // Add new zones to the database if any
            //
            var newZoneIDs = [CKRecordZoneID]()
            
            self.performReaderBlockAndWait {
                newZoneIDs = zoneIDsChanged.filter { zoneID in
                    let index = database.zones.index(where: { zone in zone.zoneID == zoneID })
                    return index == nil ? true : false
                }
            }
            
            guard !newZoneIDs.isEmpty else { return }
            
            let fetchZonesOp = CKFetchRecordZonesOperation(recordZoneIDs: newZoneIDs)
            fetchZonesOp.fetchRecordZonesCompletionBlock = { results, error in
                
                guard handleCloudKitError(error, operation: .fetchRecords) == nil,
                    let zoneDictionary = results else { return }
                
                self.performWriterBlock {
                    for (_, zone) in zoneDictionary {
                        database.zones.append(zone)
                    }
                    database.zones.sort { $0.zoneID.zoneName < $1.zoneID.zoneName }
                }
            }
            fetchZonesOp.database = database.cloudKitDB
            self.operationQueue.addOperation(fetchZonesOp)
        }
        
        // Post a notification to inform the observer after all the operations are done.
        //
        operation.database = database.cloudKitDB
        operationQueue.addOperation(operation)
        postWhenOperationQueueClear(name: .zoneCacheDidChange, object: notificationObject)
    }
    
    // Return a tuple representing the first zone in the cache.
    //
    func firstZone() -> (Database, CKRecordZone)? {
        
        return performReaderBlockAndWait {
            for database in databases where !database.zones.isEmpty {
                return (database, database.zones[0])
            }
            return nil
        }
    }
    
    // Return the zone with the specified zoneID in the specified database
    //
    func zoneWithID(_ zoneID: CKRecordZoneID, scope: CKDatabaseScope) -> CKRecordZone? {
        
        return performReaderBlockAndWait {
            for database in databases where database.cloudKitDB.databaseScope == scope {
                
                if let index = database.zones.index(where: { $0.zoneID == zoneID }) {
                    return database.zones[index]
                }
            }
            return nil
        }
    }
}

extension ZoneLocalCache { // MARK: - Add / Delete a zone
    
    func addZone(with zoneName: String, ownerName: String, to database: Database) {
        
        let zoneID = CKRecordZoneID(zoneName: zoneName, ownerName: ownerName)
        let newZone = CKRecordZone(zoneID: zoneID)
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [newZone], recordZoneIDsToDelete: nil)
        
        operation.modifyRecordZonesCompletionBlock = { (zones, zoneIDs, error) in
            
            guard handleCloudKitError(error, operation: .modifyZones, alert: true) == nil,
                let savedZone = zones?[0] else { return }
            
            self.performWriterBlock {
                if database.zones.index(where: { $0 == savedZone }) == nil {
                    database.zones.append(savedZone)
                }
                database.zones.sort(by: { $0.zoneID.zoneName < $1.zoneID.zoneName })
            }
        }
        operation.database = database.cloudKitDB
        operationQueue.addOperation(operation)
        
        let paylaod = ZoneCacheChanges(database: database, zoneIDsDeleted: [], zoneIDsChanged: [zoneID])
        let notificationObject = ZoneCacheDidChange(payload: paylaod)
        
        postWhenOperationQueueClear(name: .zoneCacheDidChange, object: notificationObject)
    }
        
    func deleteZone(_ zone: CKRecordZone, from database: Database) {
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: nil, recordZoneIDsToDelete: [zone.zoneID])
        operation.modifyRecordZonesCompletionBlock = { (_, _, error) in
            
            guard handleCloudKitError(error, operation: .modifyRecords, alert: true) == nil else { return }
            
            self.performWriterBlock {
                if let index = database.zones.index(of: zone) {
                    database.zones.remove(at: index)
                }
            }
        }
        operation.database = database.cloudKitDB
        operationQueue.addOperation(operation)
        
        let paylaod = ZoneCacheChanges(database: database, zoneIDsDeleted: [zone.zoneID], zoneIDsChanged: [])
        let notificationObject = ZoneCacheDidChange(payload: paylaod)
        
        postWhenOperationQueueClear(name: .zoneCacheDidChange, object: notificationObject)
    }
    
    func deleteCachedZone(_ zone: CKRecordZone, database: Database) {
        
        let paylaod = ZoneCacheChanges(database: database, zoneIDsDeleted: [zone.zoneID], zoneIDsChanged: [])
        let notificationObject = ZoneCacheDidChange(payload: paylaod)

        self.performWriterBlock {
            if let index = database.zones.index(of: zone) {
                database.zones.remove(at: index)
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .zoneCacheDidChange, object: notificationObject)
                }
            }
        }
    }
}
