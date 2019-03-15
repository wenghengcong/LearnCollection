/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This contains all the CloudKit functions used by this sample.
 */

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif
@import Foundation;
@import CloudKit;

extern double kNearMeDistance; // The distance (in kilometers) for searching photos near the user's location.

@protocol APLCloudManagerDelegate;

@interface APLCloudManager : NSObject

+ (NSString *)PhotoRecordType;
+ (NSString *)PhotoAssetAttribute;
+ (NSString *)PhotoTitleAttribute;
+ (NSString *)PhotoDateAttribute;
+ (NSString *)PhotoLocationAttribute;

+ (NSString *)UpdateContentWithNotification;

@property (nonatomic, weak, readwrite) id<APLCloudManagerDelegate> delegate;

@property BOOL accountAvailable;    // Indicates if the current user is logged into iCloud.

+ (APLCloudManager *)sharedInstance:(NSString *)containerID;

- (instancetype)initWithContainerIdentifier:(NSString *)containerIdentifier NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL userLoginIsValid;

// returns YES if the cloud service is available (user is logged into iCloud and has iCloud Drive turned on)
- (void)cloudServiceAvailable:(void (^)(BOOL available))completionHandler;

- (void)fetchLoggedInUserRecord:(void (^)(CKRecordID *recordID))completionHandler;
- (void)fetchUserNameFromRecordID:(CKRecordID *)recordID completionHandler:(void (^)(NSString *familyName))completionHandler;

- (void)fetchAllUsers:(void (^)(NSArray *userIdentities))completionHandler;

// Fetch all records.
- (void)fetchRecords:(void (^)(NSArray *records, NSError *error))completionHandler;

// Fetch for a record by recordID.
- (void)fetchRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

// Fetch for records based on a search predicate (used for fetching by location, recent date, and owner).
- (void)fetchRecordsWithPredicate:(NSPredicate *)predicate completionHandler:(void (^)(NSArray *records, NSError *error))completionHandler;

// Delete and save.
- (void)deleteRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler;
- (void)deleteRecordsWithIDs:(NSArray *)recordIDs completionHandler:(void (^)(NSArray *deletedRecordIDs, NSError *error))completionHandler;
- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;
- (void)modifyRecord:(CKRecord *)record completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

// Adding and creating photos.
- (NSURL *)createCachedImageFromImage:
#if TARGET_OS_IPHONE
(UIImage *)image;
#else
(NSImage *)image;
#endif

- (void)addRecordWithImage:
#if TARGET_OS_IPHONE
(UIImage *)image
#else
(NSImage *)image
#endif
title:(NSString *)title date:(NSDate *)date location:(CLLocation *)location completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

- (void)addNewRecord:(NSString *)title date:(NSDate *)date location:(CLLocation *)location completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;

- (BOOL)isMyRecord:(CKRecordID *)recordID;

// Subscription notifications
- (void)subscribe;
- (void)unsubscribe;
- (void)processNotifications;

@end


#pragma mark -

// Protocol used to inform our parent table view controller to update its table if the given record was added, changed or deleted.
@protocol APLCloudManagerDelegate <NSObject>

@required
- (void)userLoginChanged;

@end
