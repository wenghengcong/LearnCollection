/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A database wrapper for local caches.
 */

import Foundation
import CloudKit

struct Schema { // CloudKit database schema name constants.
    struct RecordType {
        static let topic = "Topic"
        static let note = "Note"
    }
    struct Topic {
        static let name = "name"
    }
    struct Note {
        static let title = "title"
        static let topic = "topic"
    }
}

class Database { // Wrap a CKDatabase, its change token, and its zones.
    var serverChangeToken: CKServerChangeToken?
    let cloudKitDB: CKDatabase
    var zones = [CKRecordZone]()
    
    init(cloudKitDB: CKDatabase) {
        self.cloudKitDB = cloudKitDB
    }
}
