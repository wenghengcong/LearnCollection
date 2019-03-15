/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base class for local caches.
 */

import Foundation
import CloudKit

extension Notification.Name {
    static let zoneCacheDidChange = Notification.Name("zoneCacheDidChange")
    static let topicCacheDidChange = Notification.Name("topicCacheDidChange")
    static let zoneDidSwitch = Notification.Name("zoneDidSwtich")
}

// Type and type alias for notification payload.
//
struct TopicCacheChanges {
    private(set) var recordIDsDeleted: [CKRecordID]
    private(set) var recordsChanged: [CKRecord]
}

struct ZoneCacheChanges {
    private(set) var database: Database
    private(set) var zoneIDsDeleted = [CKRecordZoneID]()
    private(set) var zoneIDsChanged = [CKRecordZoneID]()
}

struct ZoneSwitched {
    private(set) var database: Database
    private(set) var zone: CKRecordZone
}
// We need to capture the object and change the payload in CloudKit operation callbacks,
// so wrap the payload with a class to get the reference semantic.
//
class NotificationObject<T> {
    var payload: T?
    
    init(payload: T? = nil) {
        self.payload = payload
    }
}

typealias TopicCacheDidChange = NotificationObject<TopicCacheChanges>
typealias ZoneCacheDidChange = NotificationObject<ZoneCacheChanges>
typealias ZoneDidSwitch = NotificationObject<ZoneSwitched>

// BaseLocalCache and subclasses follow these rules to be thread-safe:
// 1. Public methods access mutable properties via "perform...".
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
// 2. Call public methods directly, otherwise will trigger a deadlock.
//
class BaseLocalCache {
    
    // A CloudKit task can be a single operation (CKDatabaseOperation) or multiple operations chained together.
    // For a single-operation task, a completion handler can be enough because CKDatabaseOperation normally
    // has a completeion handler to notify the client the task has been completed.
    // For tasks that have chained operations, we need an operation queue to waitUntilAllOperationsAreFinished
    // to know all the operations are done. This is useful for clients that need to update UI when everything is done.
    //
    lazy var operationQueue: OperationQueue = {
        return OperationQueue()
    }()
    
    // Cache can be accessed by the following paths we need protect the cache and make it thread-safe:
    // 1. Notifications -> fetchChanges -> CloudKit operation callbacks -> cache writing
    // 2. User editing -> cache writing
    // 3. User interface -> cache reading
    //
    // We use this dispatch queue to implement the following logics:
    // 1. Writer blocks should be serialized
    // 2. Reader block can be concurrent, but should wait for the enqueued writer blocks to be done.
    //
    // To achieve that, we use the following pattern:
    // 1. Use a concurrent queue, cacheQueue
    // 2. Use cacheQueue.async(flags: .barrier) {} to execute writer blocks.
    // 3. Use cacheQueue.sync(){} to execute reader blocks. The queue is concurrent, hence reader blocks
    // can be concurrent as well, unless any writer blocks is in the way.
    //
    private lazy var cacheQueue: DispatchQueue = {
        return DispatchQueue(label: "LocalCache", attributes: .concurrent)
    }()
    
    func performWriterBlock(_ writerBlock: @escaping () -> Void) {
        cacheQueue.async(flags: .barrier) {
            writerBlock()
        }
    }
    
    func performReaderBlockAndWait<T>(_ readerBlock: () -> T) -> T {
        return cacheQueue.sync {
            return readerBlock()
        }
    }
    
    // Post the notification after all the operations are done so that observers can update the UI
    // This method can be tr-entried
    //
    func postWhenOperationQueueClear(name: NSNotification.Name, object: Any? = nil) {

        DispatchQueue.global().async {
            self.operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: name, object: object)
            }
        }
    }
}
