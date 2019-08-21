/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This contains all the CloudKit functions used by this sample.
 */

#import "APLCloudManager.h"

NSString * const kPhotoRecordType = @"PhotoRecord";     // our CKRecord type
NSString * const kPhotoAsset = @"PhotoAsset";           // CKAsset
NSString * const kPhotoTitle = @"PhotoTitle";           // NSString
NSString * const kPhotoDate = @"PhotoDate";             // NSDate
NSString * const kPhotoLocation = @"PhotoLocation";     // CLLocation

NSString * const kUpdateContentWithNotification = @"UpdateContentWithNotification";

double kNearMeDistance = 5;  // the distance (in kilometers) for searching photos near the user's location

#pragma mark Error Logging

void CloudKitErrorLog(int lineNumber, NSString *functionName, NSError *error);

// generic, reusable utility routine for reporting possible CloudKit errors
void CloudKitErrorLog(int lineNumber, NSString *functionName, NSError *error)
{
    if (error != noErr)
    {
        NSMutableString *message = [NSMutableString stringWithFormat:@"\n\nAPLCloudManager ERROR [%@:%ld] ", error.domain, (long)error.code];
        if (error.localizedDescription != nil)
        {
            [message appendFormat:@"%@", error.localizedDescription];
        }
        if (error.localizedFailureReason != nil)
        {
            [message appendFormat:@", %@", error.localizedFailureReason];
        }
        
        if (error.userInfo[NSUnderlyingErrorKey] != nil)
        {
            [message appendFormat:@", %@", error.userInfo[NSUnderlyingErrorKey]];
        }
        
        if (error.localizedRecoverySuggestion != nil)
        {
            [message appendFormat:@", %@", error.localizedRecoverySuggestion];
        }
        [message appendFormat:@" - %@%d\n", functionName, lineNumber];
        NSLog(@"%@", message);
    }
}


#pragma mark -

@interface APLCloudManager ()

@property (readonly) CKContainer *container;
@property (readonly) CKDatabase *publicDatabase;

@property (readonly) CKRecordID *userRecordID;

@property (assign) CKApplicationPermissionStatus applicationPermissionStatus;   // cached so we don't have to keep asking permission status

// used for marking notifications as "read", this token tells the server what portions of the records to fetch and return to your app
@property (nonatomic, strong) CKServerChangeToken *serverChangeToken;

@property (assign) NSUInteger numberAuthenticationAttempts;
@end


#pragma mark -

@implementation APLCloudManager

+ (NSString *)PhotoRecordType { return kPhotoRecordType; }
+ (NSString *)PhotoTitleAttribute { return kPhotoTitle; }
+ (NSString *)PhotoAssetAttribute { return kPhotoAsset; }
+ (NSString *)PhotoDateAttribute { return kPhotoDate; }
+ (NSString *)PhotoLocationAttribute { return kPhotoLocation; }

+ (NSString *)UpdateContentWithNotification { return kUpdateContentWithNotification; }

// -------------------------------------------------------------------------------
//  singleton class
// -------------------------------------------------------------------------------
+ (APLCloudManager *)sharedInstance:(NSString *)containerID
{ 
    static APLCloudManager *cloudManager;  // our singleton cloud manager controller
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cloudManager = [[APLCloudManager alloc] initWithContainerIdentifier:containerID];
    });
    return cloudManager;
}

- (instancetype)init {
    
    NSAssert(NO, @"Invalid use of init; use initWithContainerIdentifier to create APLCloudManager");
    return [self init];
}

- (instancetype)initWithContainerIdentifier:(NSString *)containerIdentifier
{
    self = [super init];
    if (self != nil)
    {
        _container = [CKContainer containerWithIdentifier:containerIdentifier];
        _publicDatabase = _container.publicCloudDatabase;
        
        _applicationPermissionStatus = CKApplicationPermissionStatusInitialState;
        
        [self checkAccountAvailable:^(BOOL available) {
            if (available)
            {
                [self subscribe];
            }
        }];
        
        [self updateUserLogin:^() {
            // insert completion code here
        }];
         
        // listen for account changes (logging in or out)
        [[NSNotificationCenter defaultCenter] addObserverForName:CKAccountChangedNotification
                                                          object:nil
                                                           queue:nil // use the current queue
                                                      usingBlock:^(NSNotification *gatherNotification)
         {
             // reset our permission status and check for it again
             _applicationPermissionStatus = CKApplicationPermissionStatusInitialState;
             
             [self checkAccountAvailable:^(BOOL available) {
                 if (available)
                 {
                     [self subscribe];
                 }
             }];

             // find out about our logged in user (in case it changed)
             [self updateUserLogin:^() {
                 // call our delegate to inform them of log in change
                 [self.delegate userLoginChanged];
             }];
         }];
    }
    return self;
}

// returns YES if the cloud service is available (user is logged into iCloud and has iCloud Drive turned on)
- (void)cloudServiceAvailable:(void (^)(BOOL available))completionHandler
{
    __block BOOL serviceAvailable = NO;
    
    if (self.container != nil && self.publicDatabase != nil)
    {
        /*
         Use this method to determine the extra capabilities granted to your app by the user.
         If your app has not yet requested a specific permission, calling this method may yield the value CKApplicationPermissionStatusInitialState for the permission.
         When that value is returned, we call the requestApplicationPermission:completionHandler: method to request the permission from the user.
        */
        [self.container statusForApplicationPermission:CKApplicationPermissionUserDiscoverability
                                     completionHandler:^(CKApplicationPermissionStatus appPermissionStatus, NSError *statusError) {
            
             //CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), statusError);

             /* If this app has not yet requested a specific permission,
                calling this method may yield the value CKApplicationPermissionStatusInitialState.
             */
             if (appPermissionStatus == CKApplicationPermissionStatusInitialState)
             {
                 // We have not requested access yet, call the requestApplicationPermission to request the permission from the user.
                 [self.container requestApplicationPermission:CKApplicationPermissionUserDiscoverability
                                            completionHandler:^(CKApplicationPermissionStatus retryPermissionStatus, NSError *error) {
                                                
                    CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
                    
                    serviceAvailable = (retryPermissionStatus != CKApplicationPermissionStatusCouldNotComplete);
                    
                    /* If an error occurred when getting the application permission status,
                       we can consult the corresponding NSError for more details.
                    */
                }];
             }
             else
             {
                 /* Possible ways to get "CKApplicationPermissionStatusCouldNotComplete" error:
                    1. if the user is not logged into iCloud or does not have iCloud Drive turned on.
                    2. the client is being rate limited
                  */

                 /* If an error occurred when getting the application permission status,
                  we can consult the corresponding NSError for more details.
                  */
                 if (appPermissionStatus == CKApplicationPermissionStatusCouldNotComplete)
                 {
                     /* An error occurred when getting the application permission status, so consult the corresponding NSError.
                      
                        On CKErrorServiceUnavailable or CKErrorRequestRateLimited errors:
                        the userInfo dictionary may contain a NSNumber instance that specifies the period of time in seconds after
                        which we may retry the request.  So here we will try again.
                      */
                     
                     if (statusError.code == CKErrorServiceUnavailable || statusError.code == CKErrorRequestRateLimited)
                     {
                         NSNumber *retryAfter = statusError.userInfo[CKErrorRetryAfterKey] ? : @3; // try again after 3 seconds if we don't have a retry hint
                         NSLog(@"Error: %@. Recoverable, retry after %@ seconds", [statusError description], retryAfter);
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryAfter.intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             [self.container statusForApplicationPermission:CKApplicationPermissionUserDiscoverability
                                                          completionHandler:^(CKApplicationPermissionStatus retryAppPermissionStatus, NSError *retryError) {
                                    
                                serviceAvailable = (retryAppPermissionStatus != CKApplicationPermissionStatusCouldNotComplete);
                                                              
                                // back on the main queue, call our completion handler
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    completionHandler(serviceAvailable);
                                });
                             }];
                         });
                     }
                 }
                 else
                 {
                     serviceAvailable = (appPermissionStatus != CKApplicationPermissionStatusCouldNotComplete);
                     
                     // back on the main queue, call our completion handler
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completionHandler(serviceAvailable);
                     });
                 }
             }
        }];
    }
}


#pragma mark - Fetching

// fetch for a single record by record ID
//
- (void)fetchRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler
{
    [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *record, NSError *error) {
        
        // report any error but "record not found"
        if (error.code != CKErrorUnknownItem)
        {
            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        }
        
        // call the completion handler on the main queue
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(record, error);
        });
    }];
}

// fetch for multiple records
//
// We submit our CKQuery to a CKQueryOperation. The CKQueryOperation has the concept of cursor and a resultsLimit.
// This will allow you to bundle your query results into chunks, avoiding very long query times.
// In our case we limit to 20 at a time, and keep refetching more if available.
//
#define kResultsLimit 20

- (void)fetchRecords:(void (^)(NSArray *records, NSError *error))completionHandler
{
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];  // find "all" records
    CKQuery *query = [[CKQuery alloc] initWithRecordType:kPhotoRecordType predicate:truePredicate];
    
    // note: if we want to sort by creationDate, use this: (the Dashboard needs to set this field as sortable)
    // query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //
    // but in our case we sort alphabetically by the "kPhotoTitle" field
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kPhotoTitle ascending:YES]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    queryOperation.resultsLimit = kResultsLimit;
    queryOperation.qualityOfService = NSQualityOfServiceUserInteractive;
    
    // request these attributes (important to get all attributes in favor if our APLDetailViewController)
    queryOperation.desiredKeys = @[kPhotoTitle, kPhotoAsset, kPhotoDate, kPhotoLocation];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // defined our fetched record block so we can add each found record to our results array
    __block void (^recordFetchedBlock)(CKRecord *) = ^(CKRecord *record) {
        // found a record from the query
        [results addObject:record];
    };
    queryOperation.recordFetchedBlock = recordFetchedBlock;
    
    // define and add our completion block to fetch possibly more records, or finish by calling our caller's completion block
    __weak __block void (^block_self)(CKQueryCursor *, NSError *);
    void (^myCompletionBlock)(CKQueryCursor *, NSError *) = [^(CKQueryCursor *cursor, NSError *error) {
        
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        if (cursor != nil)
        {
            // there's more fetching to do
            CKQueryOperation *continuedQueryOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
            continuedQueryOperation.queryCompletionBlock = block_self;
            continuedQueryOperation.recordFetchedBlock = recordFetchedBlock;
            [self.publicDatabase addOperation:continuedQueryOperation];
        }
        else
        {
            // back on the main queue, call our completion handler
            dispatch_async(dispatch_get_main_queue(), ^(void) {

                // call the completion handler
                completionHandler(results, error);
            });
        }
    } copy];
    block_self = myCompletionBlock;
    
    queryOperation.queryCompletionBlock = block_self;
    [self.publicDatabase addOperation:queryOperation];
}

- (void)fetchRecordsWithPredicate:(NSPredicate *)predicate completionHandler:(void (^)(NSArray *records, NSError *error))completionHandler
{
    CKQuery *query = [[CKQuery alloc] initWithRecordType:kPhotoRecordType predicate:predicate];
    
    // note: if we want to sort by creationDate, use this: (the Dashboard needs to set this field as sortable)
    // query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //
    // but in our case we sort alphabetically by the "kPhotoTitle" field
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kPhotoTitle ascending:YES]];
    
    CKQueryOperation *photosNearQueryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    
    NSArray *desiredKeys = @[kPhotoTitle, kPhotoAsset, kPhotoDate, kPhotoLocation];
    photosNearQueryOperation.desiredKeys = desiredKeys;
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // defined our fetched record block so we can add records to our results array
    __block void (^recordFetchedBlock)(CKRecord *) = ^(CKRecord *record) {
        // found a record
        [results addObject:record];
    };
    photosNearQueryOperation.recordFetchedBlock = recordFetchedBlock;
    
    // define and add our completion block to fetch possibly more records, or finish by calling our caller's completion block
    __weak __block void (^block_self)(CKQueryCursor *, NSError *);
    void (^myCompletionBlock)(CKQueryCursor *, NSError *) = [^(CKQueryCursor *cursor, NSError *error) {
        
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        if (cursor != nil)
        {
            // there's more fetching to do
            CKQueryOperation *continuedQueryOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
            continuedQueryOperation.desiredKeys = desiredKeys;
            continuedQueryOperation.queryCompletionBlock = block_self;
            continuedQueryOperation.recordFetchedBlock = recordFetchedBlock;
            [self.publicDatabase addOperation:continuedQueryOperation];
        }
        
        // back on the main queue, call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(results, error);
        });
    } copy];
    
    block_self = myCompletionBlock;
    
    photosNearQueryOperation.queryCompletionBlock = block_self;
    [self.publicDatabase addOperation:photosNearQueryOperation];
}

- (BOOL)isMyRecord:(CKRecordID *)recordID
{
    return ([recordID.recordName isEqual:CKCurrentUserDefaultName] && self.userRecordID != nil);
}


#pragma mark - Deleting and Saving

- (void)deleteRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecordID *recordID, NSError *error))completionHandler
{
    [self.publicDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID *deletedRecordID, NSError *error) {
        
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        // back on the main queue, call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(deletedRecordID, error);
        });
    }];
}

- (void)deleteRecordsWithIDs:(NSArray *)recordIDs completionHandler:(void (^)(NSArray *deletedRecordIDs, NSError *error))completionHandler
{
    // we use CKModifyRecordsOperation to delete multiple records
    CKModifyRecordsOperation *operation =
        [[CKModifyRecordsOperation alloc] initWithRecordsToSave:nil recordIDsToDelete:recordIDs];
    operation.savePolicy = CKRecordSaveIfServerRecordUnchanged;
    operation.queuePriority = NSOperationQueuePriorityHigh;
    
    // The following Quality of Service (QoS) is used to indicate to the system the nature and importance of this work.
    // Higher QoS classes receive more resources than lower ones during resource contention.
    //
    operation.qualityOfService = NSQualityOfServiceUserInitiated;
    
    // add the completion for the entire delete operation
    operation.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *error) {

        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        // back on the main queue, call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(deletedRecordIDs, error);
        });
    };

    // start the operation
    [self.publicDatabase addOperation:operation];
}

- (void)saveRecord:(CKRecord *)record completionHandler:(void (^)(CKRecord *savedRecord, NSError *error))completionHandler
{
    [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *savedRecord, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
            
            // back on the main queue, call our completion handler
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                completionHandler(savedRecord, error);
            });
        });
    }];
}

- (void)modifyRecord:(CKRecord *)recordToModify completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler
{
    // we use CKModifyRecordsOperation to modify records (in this case one record)
    CKModifyRecordsOperation *operation =
        [[CKModifyRecordsOperation alloc] initWithRecordsToSave:@[recordToModify] recordIDsToDelete:nil];
    operation.savePolicy = CKRecordSaveIfServerRecordUnchanged;
    operation.queuePriority = NSOperationQueuePriorityHigh;

    // The following Quality of Service (QoS) is used to indicate to the system the nature and importance of this work.
    // Higher QoS classes receive more resources than lower ones during resource contention.
    //
    operation.qualityOfService = NSQualityOfServiceUserInitiated;

    // report the progress on a per record basis
    operation.perRecordProgressBlock = ^(CKRecord *record, double progress) {
        //NSLog(@"modifying record: %.0f%% complete", progress*100);
    };
    
    // completed completion block for the once modified record
    operation.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *operationError) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if (operationError != nil)
            {
                CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
            }
            
            // We are checking for only one modified record here.
            CKRecord *modifiedRecord = (savedRecords.count == 1) ? savedRecords[0] : nil;
            
            // Call our completion with the saved record (or nil if failed).
            completionHandler(modifiedRecord, operationError);
        });
    };
    
    // callback for each record modified (here we only modify one record but...
    //  for illustration purposes we show how to deal with modifying multiple records
    //
    operation.perRecordCompletionBlock = ^(CKRecord *record, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if (error != nil)
            {
                CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);

                if (error.code == CKErrorServerRecordChanged)
                {
                    // CKRecordChangedErrorAncestorRecordKey:
                    // Key to the original CKRecord that you used as the basis for making your changes.
                    CKRecord *ancestorRecord = error.userInfo[CKRecordChangedErrorAncestorRecordKey];
                    
                    // CKRecordChangedErrorServerRecordKey:
                    // Key to the CKRecord that was found on the server. Use this record as the basis for merging your changes.
                    CKRecord *serverRecord = error.userInfo[CKRecordChangedErrorServerRecordKey];
                    
                    // CKRecordChangedErrorClientRecordKey:
                    // Key to the CKRecord that you tried to save.
                    // This record is based on the record in the CKRecordChangedErrorAncestorRecordKey key but contains the additional changes you made.
                    CKRecord *clientRecord = error.userInfo[CKRecordChangedErrorClientRecordKey];
                    
                    NSAssert(ancestorRecord != nil || serverRecord != nil || clientRecord != nil,
                             @"Error CKModifyRecordsOperation, can't obtain ancestor, server or client records to resolve conflict.");
                    
                    // important to use the server's record as a basis for our changes,
                    // apply our current record to the server's version
                    //
                    serverRecord[kPhotoTitle] = clientRecord[kPhotoTitle];
                    serverRecord[kPhotoAsset] = clientRecord[kPhotoAsset];
                    serverRecord[kPhotoDate] = clientRecord[kPhotoDate];
                    serverRecord[kPhotoLocation] = clientRecord[kPhotoLocation];
                
                    // save the newer record
                    [self.publicDatabase saveRecord:serverRecord completionHandler:^(CKRecord *savedRecord, NSError *saveError) {
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            // success, return the saved record
                            completionHandler(savedRecord, saveError);
                        });
                    }];
                }
            }
        });
    };
    
    // start the modify operation
    [self.publicDatabase addOperation:operation];
}


#pragma mark - Photo Utilities

// this will create a sized down/compressed cached image in the caches folder

- (NSURL *)createCachedImageFromImage:
#if TARGET_OS_IPHONE
(UIImage *)image
#else
(NSImage *)image
#endif
{
    NSURL *resultURL = nil;
    CGSize cacheImageSize = {512, 512}; // the size we want for the stored image CKAsset
    
    if (image != nil)
    {
        if (image.size.width > image.size.height)
        {
            cacheImageSize.height = round(cacheImageSize.width * image.size.height / image.size.width);
        }
        else
        {
            cacheImageSize.width = round(cacheImageSize.height * image.size.width / image.size.height);
        }
        
        NSData *imageData;
        
#if TARGET_OS_IPHONE
        UIGraphicsBeginImageContext(cacheImageSize);
        [image drawInRect:CGRectMake(0, 0, cacheImageSize.width, cacheImageSize.height)];
        
        imageData = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.75);
        UIGraphicsEndImageContext();
#else
        imageData = image.TIFFRepresentation;
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSNumber *compressionFactor = @0.9f;
        NSDictionary *imageProps = @{NSImageCompressionFactor: compressionFactor};
        imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
#endif
        
        // write the image out to a cache file
        NSURL *cachesDirectory = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                        inDomain:NSUserDomainMask
                                                               appropriateForURL:nil
                                                                          create:YES
                                                                           error:nil];
        NSString *temporaryName = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"jpeg"];
        resultURL = [cachesDirectory URLByAppendingPathComponent:temporaryName];
        [imageData writeToURL:resultURL atomically:YES];
    }
    
    return resultURL;
}

- (void)addNewRecord:(NSString *)title date:(NSDate *)date location:(CLLocation *)location completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler
{
    CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:[APLCloudManager PhotoRecordType]];
    newRecord[[APLCloudManager PhotoTitleAttribute]] = title;
    newRecord[[APLCloudManager PhotoDateAttribute]] = date;
    newRecord[[APLCloudManager PhotoLocationAttribute]] = location;
    
    [self saveRecord:newRecord completionHandler:^(CKRecord *record, NSError *error) {
        if (error != nil)
        {
            // if there are no records defined in iCloud dashboard you will get this error:
            /* error 9 {
             NSDebugDescription = "CKInternalErrorDomain: 1004";
             NSLocalizedDescription = "Account couldn't get container scoped user id, no underlying error received"
             */
            
            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        }
        completionHandler(record, error);
    }];
}


- (void)addRecordWithImage:
#if TARGET_OS_IPHONE
                (UIImage *)image
#else
                (NSImage *)image
#endif
                     title:(NSString *)title
                      date:(NSDate *)date
                  location:(CLLocation *)location
         completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler
{
    CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:[APLCloudManager PhotoRecordType]];
    newRecord[[APLCloudManager PhotoTitleAttribute]] = title;
    newRecord[[APLCloudManager PhotoDateAttribute]] = date;
    newRecord[[APLCloudManager PhotoLocationAttribute]] = location;
    
    // this will create a sized down/compressed cached image in the caches folder
    NSURL *imageURL = [self createCachedImageFromImage:image];
    if (imageURL != nil)
    {
        CKAsset *asset = [[CKAsset alloc] initWithFileURL:imageURL];
        newRecord[[APLCloudManager PhotoAssetAttribute]] = asset;
    }
    
    [self saveRecord:newRecord completionHandler:^(CKRecord *record, NSError *error) {
        if (error != nil)
        {
            // if there are no records defined in iCloud dashboard you will get this error:
            /* error 9 {
             NSDebugDescription = "CKInternalErrorDomain: 1004";
             NSLocalizedDescription = "Account couldn't get container scoped user id, no underlying error received"
             */

            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        }
        completionHandler(record, error);
    }];
}


#pragma mark - Subscriptions and Notifications

- (void)saveSubscription:(CKSubscription *)subscriptionInfo completionHandler:(void (^)(NSError *error))completionHandler
{
    CKModifySubscriptionsOperation *modifyOperation = [[CKModifySubscriptionsOperation alloc] init];
    modifyOperation.subscriptionsToSave = @[subscriptionInfo];
    
    modifyOperation.modifySubscriptionsCompletionBlock = ^(NSArray *savedSubscriptions, NSArray *deletedSubscriptionIDs, NSError *error) {
        
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        if (error.code == CKErrorServerRejectedRequest)
        {
            // save subscription request rejected!
            // trying to save a subscribution (subscribe) failed (probably because we already have a subscription saved)
            //
            // this is likely due to the fact that the app was deleted and reinstalled to the device,
            // so assume we have a subscription already registed with the server
            //
        }
        else if (error.code == CKErrorNotAuthenticated)
        {
            // could not subscribe (not authenticated)
            //NSLog(@"User not authenticated (could not subscribe to record changes)");
        }
        else if (error.code == CKErrorPartialFailure)
        {
            // some items failed, but the operation succeeded overall
            NSLog(@"\r\rpartial errors in saving our subscription,\r(some items failed, but the operation succeeded overall).\rUnable to save subscriptions.\r");
        }
        
        // back on the main queue, store as a default and call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            completionHandler(error);  // we are done
        });
    };
    
    [self.publicDatabase addOperation:modifyOperation];
}

- (void)startSubscriptions
{
    // subscribe to deletion, update and creation of our record type
    //
    // Note: for each user a separate CKSubscription will be saved to the cloud for their account
    //
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];  // we are interested in "all" changes to kRecordType
 
    // 1) subscribe to record creation, updates and deletions
    __block CKQuerySubscription *itemSubscription =
        [[CKQuerySubscription alloc] initWithRecordType:kPhotoRecordType
                                              predicate:truePredicate
                                                options:CKQuerySubscriptionOptionsFiresOnRecordCreation | CKQuerySubscriptionOptionsFiresOnRecordUpdate |
                                                     CKQuerySubscriptionOptionsFiresOnRecordDeletion];
    
    CKNotificationInfo *notification = [[CKNotificationInfo alloc] init];
    
    // 2) set the notification content:
    //
    // note: if you don't set "alertBody", "soundName" or "shouldBadge", it will make the notification a priority, sent at an opportune time
    //
    notification.alertBody = NSLocalizedString(@"Notif alert body", nil);
    
    // 3) allows the action to launch the app if it’s not running. Once launched, the notifications will be delivered,
    // and the app will be given some background time to process them.
    //
    // Indicates that the notification should be sent with the "content-available" flag
    // to allow for background downloads in the application. Default value is NO.
    //
    notification.shouldSendContentAvailable = YES;

    // 4) optional
    notification.soundName = @"Hero.aiff";   // or default: UILocalNotificationDefaultSoundName

    // below identifies an image in your bundle to be shown as an alternate launch image
    // when launching from the notification, this is used on this case:
    //      1. app is launched
    //      2. device is turned off and on again
    //      3. change CKRecord on another device
    //      4. notif arrives, tap open or tap banner and the launch image (all pink) shows
    //
    //notification.alertLaunchImage = @"<your launch image>.png";

    // 5) a list of keys from the matching record to include in the notification payload,
    // here are are only interested in the title (kPhotoAsset can't be a desired key, unsupported)
    //
    notification.desiredKeys = @[kPhotoTitle];

    // set our CKNotificationInfo to our CKSubscription
    itemSubscription.notificationInfo = notification;
    
    // save our subscription,
    // note: that if saving multiple subscriptions, they should be saved in succession, and not independently
    //
    [self saveSubscription:itemSubscription completionHandler:^(NSError *error) {
        //..
    }];
}

- (void)subscribe
{
    // find any subscription saved on the server
    CKFetchSubscriptionsOperation *fetchSubscriptionsOperation = [CKFetchSubscriptionsOperation fetchAllSubscriptionsOperation];
    fetchSubscriptionsOperation.fetchSubscriptionCompletionBlock = ^(NSDictionary *subscriptionsBySubscriptionID, NSError *operationError) {
        
        if (operationError != nil)
        {
             // error in fetching our subscription
             CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
             
             if (operationError.code == CKErrorNotAuthenticated)
             {
                 // try again after 3 seconds if we don't have a retry hint
                 //
                 NSNumber *retryAfter = operationError.userInfo[CKErrorRetryAfterKey] ? : @3;
                 NSLog(@"Error: %@. Recoverable, retry after %@ seconds", operationError.description, retryAfter);
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryAfter.intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self subscribe];  // call this method again to retry
                 });
             }
             else if (operationError.code == CKErrorBadContainer)
             {
                 // Un-provisioned or unauthorized container. Try provisioning the container before retrying the operation.
             }
        }
        else
        {
            if (subscriptionsBySubscriptionID != nil && subscriptionsBySubscriptionID.count > 0)
            {
                // found an existing subscription, not necessary to subscribe again
            }
            else
            {
                // still no subscriptions found on the server, so save a new subscription
                //
                [self startSubscriptions];
            }
        }
    };
    [self.publicDatabase addOperation:fetchSubscriptionsOperation];
}

- (void)unsubscribe
{
    CKFetchSubscriptionsOperation *fetchSubscriptionsOperation = [CKFetchSubscriptionsOperation fetchAllSubscriptionsOperation];
    fetchSubscriptionsOperation.fetchSubscriptionCompletionBlock = ^(NSDictionary *subscriptionsBySubscriptionID, NSError *operationError) {
        if (operationError != nil)
        {
            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
        }
        else
        {
            if (subscriptionsBySubscriptionID != nil && subscriptionsBySubscriptionID.count > 0)
            {
                // we already have one or more CKSubscriptions registered with the server,
                // we want to modify our current subscription and delete the subscription ID from it
                //
                NSArray *subscriptionIDs = [subscriptionsBySubscriptionID allKeys];
                
                CKModifySubscriptionsOperation *modifyOperation = [[CKModifySubscriptionsOperation alloc] init];
                modifyOperation.subscriptionIDsToDelete = subscriptionIDs;
                
                modifyOperation.modifySubscriptionsCompletionBlock = ^(NSArray *savedSubscriptions, NSArray *deletedSubscriptionIDs, NSError *error) {
                    if (error != nil)
                    {
                        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
                    }
                    else
                    {
                        // successfully unsubscribed
                    }
                };

                [self.publicDatabase addOperation:modifyOperation];
            }
            else
            {
                // no subscriptions found, unsubscribe not necessary
            }
        }
    };
    [self.publicDatabase addOperation:fetchSubscriptionsOperation];
}

- (void)processNotifications
{
    // note this is called recusrively for processing additional pending notifications
    [self processNotifications:self.serverChangeToken];
}

- (void)processNotifications:(CKServerChangeToken *)serverChangeToken
{
    // each item in the notification queue need to be marked as "read" so next time we won't be concerned about them
    //
    __block NSMutableArray *itemsToMarkAsRead = [NSMutableArray array];
    
    // this operation will fetch all notification changes,
    // if a change anchor from a previous CKFetchNotificationChangesOperation is passed in,
    // only the notifications that have changed since that anchor will be fetched.
    //
    CKFetchNotificationChangesOperation *fetchChangesOperation =
        [[CKFetchNotificationChangesOperation alloc] initWithPreviousServerChangeToken:self.serverChangeToken];
    
    __weak CKFetchNotificationChangesOperation *weakFetchChangesOperation = fetchChangesOperation;
    
    fetchChangesOperation.fetchNotificationChangesCompletionBlock = ^(CKServerChangeToken *newerServerChangeToken, NSError *operationError) {
        if (operationError != nil)
        {
            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
        }
        else
        {
            // If "moreComing" is set then the server wasn't able to return all the changes in this response,
            // another CKFetchNotificationChangesOperation operation should be run with the updated serverChangeToken token from this operation.
            //
            if (weakFetchChangesOperation.moreComing)
            {
                [self processNotifications:newerServerChangeToken];
            }
            else
            {
                _serverChangeToken = newerServerChangeToken;
            }
        }
    };
    
    // this block processes a single push notification
    fetchChangesOperation.notificationChangedBlock = ^(CKNotification *notification) {
        if (notification.notificationType != CKNotificationTypeReadNotification)
        {
            CKNotificationType notificationType = notification.notificationType;
            
            // send only query notifications to our client UI
            if (notificationType == CKNotificationTypeQuery)
            {
                // post the custom notification on the main queue (to any interested view controller)
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateContentWithNotification object:notification];
                });  
            }
                
            [itemsToMarkAsRead addObject:notification.notificationID];  // add the CKQueryNotification's notif ID to our array so that it can be marked as read
        }
    };
    
    // this block is executed after all requested notifications are fetched
    fetchChangesOperation.completionBlock = ^{
        //NSLog(@"found %lu items in the change notif queue", (unsigned long)array.count);
        
        // mark all of them as "read"
        CKMarkNotificationsReadOperation *markNotifsReadOperation = [[CKMarkNotificationsReadOperation alloc] initWithNotificationIDsToMarkRead:itemsToMarkAsRead];
        
        markNotifsReadOperation.markNotificationsReadCompletionBlock = ^ (NSArray *notificationIDsMarkedRead, NSError *operationError) {
            if (operationError != nil)
            {
                CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
      
                //NSLog(@"Unable to mark notifs as read: %@", operationError);
            }
            else
            {
                // finished marking the notifications as "read"
                //NSLog(@"items marked as read = %lu", (unsigned long)notificationIDsMarkedRead.count);
            }
        };
        
        [self.container addOperation:markNotifsReadOperation];
    };
    
    [self.container addOperation:fetchChangesOperation];
}


#pragma mark - User Discoverability

// returns YES if the user has logged into iCloud
- (BOOL)userLoginIsValid
{
    return (self.userRecordID != nil);
}

// check the user account status (are we logged in?)
- (void)checkAccountAvailable:(void (^)(BOOL available))completionHandler
{
    [self.container accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
    
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        switch (accountStatus) {
        case CKAccountStatusCouldNotDetermine:
            // an error occurred when getting the account status, consult the corresponding NSError
            break;
            
        case CKAccountStatusRestricted:
            // Parental Controls / Device Management has denied access to iCloud account credentials
            break;
            
        case CKAccountStatusNoAccount:
            // no iCloud account is logged in on this device
            break;
            
        default: break;
        }
        
        // back on the main queue, call our completion handler with the available result
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            // note: accountStatus could be "CKAccountStatusAvailable", and at the same time there could be no network,
            // in this case the user should not be able to add, remove or modify photos
            //
            // (CKAccountStatusAvailable = The iCloud account credentials are available for this application)
            //
            _accountAvailable = (accountStatus == CKAccountStatusAvailable);
            
            completionHandler(self.accountAvailable);
        });
    }];
}

// Asks for discoverability permission from the user.
//
// This will bring up an alert: "Allow people using "CloudPhotos" to look you up by email?",
// clicking "Don't Allow" will not make you discoverable.
//
// The first time you request a permission on any of the user’s devices, the user is prompted to grant or deny the request.
// Once the user grants or denies a permission, subsequent requests for the same permission
// (on the same or separate devices) do not prompt the user again.
//
- (void)requestDiscoverabilityPermission:(void (^)(BOOL discoverable)) completionHandler {
    
    if (self.applicationPermissionStatus == CKApplicationPermissionStatusGranted ||
        self.applicationPermissionStatus == CKApplicationPermissionStatusDenied)
    {
        // We already know our user's permission, so just call the completion handler back on the main queue.
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(self.applicationPermissionStatus == CKApplicationPermissionStatusGranted);
        });
    }
    else
    {
        [self.container requestApplicationPermission:CKApplicationPermissionUserDiscoverability
                               completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError *error) {

            CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
                                       
            if (error.code != CKErrorNetworkUnavailable && applicationPermissionStatus == CKApplicationPermissionStatusCouldNotComplete)
            {
                // An error occurred when getting the application permission status,
                // (likely because we are logged out or iCloud Drive is off) so consult the corresponding NSError.
                
                // Try again after 3 seconds if we don't have a retry hint.
                //
                NSNumber *retryAfter = error.userInfo[CKErrorRetryAfterKey] ? : @3;
                
                if (self.numberAuthenticationAttempts < 3)  // retry only 3 times before giving up
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryAfter.intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                        [self requestDiscoverabilityPermission:completionHandler];  // Call this method again to retry.
                        _numberAuthenticationAttempts++;
                    });
                }
                else
                {
                    // Four attempts have been made already, we are giving up here.
                    _numberAuthenticationAttempts = 0;
                    
                    CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);  // Report the error for one last time.
                    NSLog(@"\n\nGIVING UP: on requesting user discovering permissions\n");
                }
            }
            else
            {
                _applicationPermissionStatus = applicationPermissionStatus;
            }
                                   
            // Back on the main queue, call our completion handler.
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(self.applicationPermissionStatus == CKApplicationPermissionStatusGranted);
            });
        }];
    }
    
}

// obtain information on all users in our Address Book
// how this is called:
//
//  [self fetchAllUsers:^(NSArray *userIdentities) { }];
//
- (void)fetchAllUsers:(void (^)(NSArray *userIdentities))completionHandler
{
    // find all discoverable users in the device's address book
    //
    __block NSMutableArray *allUsers = [NSMutableArray array];
    
    CKDiscoverAllUserIdentitiesOperation *op = [[CKDiscoverAllUserIdentitiesOperation alloc] init];
    op.queuePriority = NSOperationQueuePriorityNormal;
    
    op.userIdentityDiscoveredBlock = ^(CKUserIdentity *identity) {
        [allUsers addObject:identity];
    };
    
    op.discoverAllUserIdentitiesCompletionBlock = ^(NSError *error) {
        
        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
        
        // back on the main queue, call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionHandler(allUsers);
        });
    };
    [self.container addOperation:op];
    
    // or directly without NSOperation
    /*[self.container discoverAllContactUserInfosWithCompletionHandler:^(NSArray *userInfos, NSError *error) {
        
        // back on the main queue, call our completion handler
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];*/
}

// obtain the current logged in user's CKRecordID
//
- (void)fetchLoggedInUserRecord:(void (^)(CKRecordID *recordID))completionHandler
{
    if (self.userRecordID != nil)   // don't request it again, if we already have the user's record
    {
        completionHandler(self.userRecordID);
    }
    else
    {
        [self requestDiscoverabilityPermission:^(BOOL discoverable) {

            if (discoverable)
            {
                [self.container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {

                    CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);

                    // back on the main queue, call our completion handler
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        _userRecordID = recordID;
                        completionHandler(recordID);    // invoke our caller's completion handler indicating we are done
                    });
                }];
            }
            else
            {
                // can't discover user, return nil user recordID back on the main queue
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    // invoke our caller's completion handler with a nil user record ID, indicating we are done
                    completionHandler(nil);
                });
            }
        }];
    }
}

// Discover the given CKRecordID's user's info with CKDiscoverUserInfosOperation,
// return in its completion handler the last name and first name, if possible.
// Users of an app must opt in to discoverability before their user records can be accessed.
//
- (void)fetchUserNameFromRecordID:(CKRecordID *)recordID completionHandler:(void (^)(NSString *familyName))completionHandler
{
    NSAssert(recordID != nil, @"Error fetchUserNameFromRecordID, incoming recordID is nil");
    
    // first find our own login user recordID
    [self fetchLoggedInUserRecord:^(CKRecordID *loggedInUserRecordID) {
    
        CKRecordID *recordIDToUse = nil;
        
        // we found our login user recordID, is it our photo?
        if ([self isMyRecord:recordID])
        {
            // we own this record, so look up our user name using our login recordID
            recordIDToUse = loggedInUserRecordID;
        }
        else
        {
            // this recordID is owned by another user, find its user info using the incoming "recordID" directly
            recordIDToUse = recordID;
        }
        
        if (recordIDToUse != nil)
        {
            __block NSMutableArray *userIdentities = [NSMutableArray array];
            
            CKUserIdentityLookupInfo *userLookupInfo = [[CKUserIdentityLookupInfo alloc] initWithUserRecordID:recordID];
            CKDiscoverUserIdentitiesOperation *discoverOperation = [[CKDiscoverUserIdentitiesOperation alloc] initWithUserIdentityLookupInfos:@[userLookupInfo]];
            
            // note this block may not be called if the user is logged out of iCloud
            discoverOperation.userIdentityDiscoveredBlock = ^(CKUserIdentity *identity, CKUserIdentityLookupInfo *lookupInfo)
            {
                NSPersonNameComponents *nameComponents = [identity nameComponents];
                [userIdentities addObject:nameComponents.familyName];
            };
  
            discoverOperation.discoverUserIdentitiesCompletionBlock = ^(NSError * _Nullable operationError)
            {
                CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), operationError);
            
                // back on the main queue, call our completion handler with the results
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    // note by now, if userIdentities array is empty, it's likely the user is logged out of iCloud
                    NSString *userName = NSLocalizedString(@"Undetermined Login Name", nil);
                    if (userIdentities.count > 0)
                    {
                        userName = userIdentities[0];
                    }
                    
                    completionHandler(userName);
                });
            };
        
            [self.container addOperation:discoverOperation];
        }
        else
        {
            // could not find our login user recordID (probably because we are logged out or the user are not discoverable)
            // report back with a generic name
            //
            // back on the main queue, call our completion handler
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                completionHandler(NSLocalizedString(@"Undetermined Login Name", nil));
            });
        }
    }];
}

// used to update our user information (in case user logged out/in or with a different account),
// typically you call this when the app becomes active from launch or from the background.
//
- (void)updateUserLogin:(void (^)(void))completionHandler
{
    // first ask for discoverability permission from the user
    [self requestDiscoverabilityPermission:^(BOOL discoverable) {
    
        // first obtain the CKRecordID of the logged in user (we use it to find the user's contact info)
        //
        [self.container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
            
            if (error != nil)
            {
                // no user information will be known at this time
                _userRecordID = nil;
                
                CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), error);
                
                // back on the main queue, call our completion handler
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    // no user information found, due to an error, invoke our caller's completion handler indicating we are done
                    completionHandler();
                });
            }
            else
            {
                _userRecordID = recordID;
                
                // retrieve info about the logged in user using it's CKRecordID
                [self.container discoverUserIdentityWithUserRecordID:recordID completionHandler:^(CKUserIdentity *userInfo, NSError *discoverError) {
                    if (discoverError != nil)
                    {
                        // if we get network failure error (4), we still get back a recordID, which means no access to CloudKit container
                        CloudKitErrorLog(__LINE__, NSStringFromSelector(_cmd), discoverError);
                    }
                    else
                    {
                        //NSLog(@"logged in as '%@ %@'", userInfo.nameComponents.givenName, userInfo.nameComponents.familyName);
                    }
                    
                    // back on the main queue, call our completion handler
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        completionHandler();    // invoke our caller's completion handler indicating we are done
                    });
                }];
            }
        }];
    }];
}

@end
