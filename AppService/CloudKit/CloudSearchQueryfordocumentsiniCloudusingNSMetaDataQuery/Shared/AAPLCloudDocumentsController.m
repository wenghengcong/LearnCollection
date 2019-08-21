/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class used to keep track of known documents in the cloud.
 */

#import "AAPLCloudDocumentsController.h"

@interface AAPLCloudDocumentsController ()

@property (nonatomic, strong) NSMetadataQuery *ubiquitousQuery;
@property (nonatomic, strong) NSArray *sortedResults;

@property id metadataQueryStartObserver;
@property id metadataQueryGatherObserver;
@property id metadataQueryUpdateObserver;
@property id metadataQueryFinishObserver;

@end


#pragma mark -

@implementation AAPLCloudDocumentsController

// -------------------------------------------------------------------------------
//  singleton class
// -------------------------------------------------------------------------------
+ (AAPLCloudDocumentsController *)sharedInstance
{
    static AAPLCloudDocumentsController *cloudDocumentsController;  // our singleton controller
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // note: an empty file type means find all types of documents
        cloudDocumentsController = [[AAPLCloudDocumentsController alloc] initWithType:@""];
    });
    return cloudDocumentsController;
}

// -------------------------------------------------------------------------------
//  init
// -------------------------------------------------------------------------------
- (instancetype)init
{
    return [self initWithType:@""];
}

// -------------------------------------------------------------------------------
//  initWithType:fileType
// -------------------------------------------------------------------------------
- (instancetype)initWithType:(NSString *)fileType
{
    self = [super init];
    if (self != nil)
    {
        _fileType = fileType;
        [self setupQuery];
    }
    return self;
}

// -------------------------------------------------------------------------------
//  changeQueryCriteria:fileType
// -------------------------------------------------------------------------------
- (void)changeQueryCriteria:(NSString *)fileType
{
    NSString *filePattern = nil;
    if ([self.fileType isEqualToString:@""])
    {
        filePattern = [NSString stringWithFormat:@"*.*"];
    }
    else
    {
        filePattern = [NSString stringWithFormat:@"*.%@", self.fileType];
    }
    
    self.ubiquitousQuery.predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", NSMetadataItemFSNameKey, filePattern];
    // or
    // self.ubiquitousQuery.predicate = [NSPredicate predicateWithFormat:@"%K ENDSWITH %@", NSMetadataItemFSNameKey, self.fileType];
}

// -------------------------------------------------------------------------------
//  handleQueryUpdates:ubiquitousQuery
//
//  Used for examining what new results came from our NSMetadataQuery.
//  This method is shared between "finishGathering" and "didUpdate" methods.
// -------------------------------------------------------------------------------
- (void)handleQueryUpdates:(NSMetadataQuery *)ubiquitousQuery
{
    // sort the results
    _sortedResults = [self.ubiquitousQuery.results sortedArrayUsingComparator:^NSComparisonResult(id firstObj, id secondObj) {
        NSString *firstTitle = [firstObj valueForAttribute:NSMetadataItemDisplayNameKey];
        NSString *secondTitle = [secondObj valueForAttribute:NSMetadataItemDisplayNameKey];
        return [firstTitle localizedCompare:secondTitle];
    }];
    
    // notify our delegate we received an update
    if ([self.delegate respondsToSelector:@selector(didRetrieveCloudDocuments)])
    {
        [self.delegate didRetrieveCloudDocuments];
    }
}

// -------------------------------------------------------------------------------
//  setupQuery
// -------------------------------------------------------------------------------
- (void)setupQuery
{
    _ubiquitousQuery = [[NSMetadataQuery alloc] init];
    self.ubiquitousQuery.notificationBatchingInterval = 15;
    self.ubiquitousQuery.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
    
    [self changeQueryCriteria:self.fileType];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    self.ubiquitousQuery.operationQueue = queue;
    
    __weak AAPLCloudDocumentsController *weakSelf = self;
    
    self.metadataQueryStartObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSMetadataQueryDidStartGatheringNotification object:self.ubiquitousQuery queue:queue usingBlock:^(NSNotification *gatherNotification)
        {
            // use "weakSelf" to refer back to the object that owns this query
            if (weakSelf != nil)
            {
                NSMetadataQuery *const query = gatherNotification.object;
                
                // we should invoke this method before iterating over query results that could change due to live updates
                [query disableUpdates];
                
                NSLog(@"didStart...");
                
                // call our delegate that we started scanning out ubiquitous container
                if ([weakSelf.delegate respondsToSelector:@selector(didStartRetrievingCloudDocuments)])
                {
                    [weakSelf.delegate didStartRetrievingCloudDocuments];
                }
                
                // enable updates again
                [query enableUpdates];
            }
        }];
    
    self.metadataQueryGatherObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSMetadataQueryDidFinishGatheringNotification object:self.ubiquitousQuery queue:queue usingBlock:^(NSNotification *gatherNotification)
        {
            // use "weakSelf" to refer back to the object that owns this query
            if (weakSelf != nil)
            {
                NSMetadataQuery *const query = gatherNotification.object;
                
                // we should invoke this method before iterating over query results that could change due to live updates
                [query disableUpdates];
                
                NSLog(@"finishGathering...");
                
                [weakSelf handleQueryUpdates:self.ubiquitousQuery];
                
                // enable updates again
                [query enableUpdates];
            }
        }];

    self.metadataQueryUpdateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSMetadataQueryDidUpdateNotification object:self.ubiquitousQuery queue:queue usingBlock:^(NSNotification *queryUpdateNotification)
        {
            // use "weakSelf" to refer back to the object that owns this query
            if (weakSelf != nil)
            {
                NSMetadataQuery *const query = queryUpdateNotification.object;
                
                // we should invoke this method before iterating over query results that could change due to live updates
                [query disableUpdates];
                
                NSLog(@"didUpdate...");
                [weakSelf handleQueryUpdates:self.ubiquitousQuery];
                
                // enable updates again
                [query enableUpdates];
            }
        }];
    
    self.metadataQueryGatherObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSMetadataQueryGatheringProgressNotification object:self.ubiquitousQuery queue:queue usingBlock:^(NSNotification *queryUpdateNotification)
        {
            // use "weakSelf" to refer back to the object that owns this query
            if (weakSelf != nil)
            {
                NSMetadataQuery *const query = queryUpdateNotification.object;
                
                // we should invoke this method before iterating over query results that could change due to live updates
                [query disableUpdates];
                
                NSLog(@"gathering...");
                //.. do what ever you need to do while gathering results
                
                // enable updates again
                [query enableUpdates];
            }
        }];
}

- (void)removeQuery
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.metadataQueryStartObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.metadataQueryGatherObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.metadataQueryFinishObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.metadataQueryUpdateObserver];
    [self stopScanning];
    _ubiquitousQuery = nil;
}

// -------------------------------------------------------------------------------
//  setFileType
//
//  Our client is explicty setting the file type, so we need to re-setup the query.
// -------------------------------------------------------------------------------
- (void)setFileType:(NSString *)fileType
{
    _fileType = fileType;
    [self changeQueryCriteria:_fileType];
}


#pragma mark - Exported APIs

// -------------------------------------------------------------------------------
//  numberOfDocuments
// -------------------------------------------------------------------------------
- (NSUInteger)numberOfDocuments
{
    return self.sortedResults.count;
}

// -------------------------------------------------------------------------------
//  startScanning
// -------------------------------------------------------------------------------
- (BOOL)startScanning
{
    return [self.ubiquitousQuery startQuery];
}

// -------------------------------------------------------------------------------
//  stopScanning
// -------------------------------------------------------------------------------
- (void)stopScanning
{
    [self.ubiquitousQuery stopQuery];
    _sortedResults = nil;
}

// -------------------------------------------------------------------------------
//  restartScan
// -------------------------------------------------------------------------------
- (void)restartScan
{
    [self stopScanning];
    [self startScanning];
}

// -------------------------------------------------------------------------------
//  urlForDocumentAtIndex:index
// -------------------------------------------------------------------------------
- (NSURL *)urlForDocumentAtIndex:(NSInteger)index
{
    NSMetadataItem *item = self.sortedResults[index];
    return [item valueForAttribute:NSMetadataItemURLKey];
}

// -------------------------------------------------------------------------------
//  documentTitleForDocumentAtIndex:index
// -------------------------------------------------------------------------------
- (NSString *)documentTitleForDocumentAtIndex:(NSInteger)index
{
    NSURL *url = [self urlForDocumentAtIndex:index];
    return url.lastPathComponent;
}

// -------------------------------------------------------------------------------
//  localizedTitleForDocumentAtIndex
// -------------------------------------------------------------------------------
- (NSString *)localizedTitleForDocumentAtIndex:(NSInteger)index
{    
    // obtain localized name
    NSURL *url = [self urlForDocumentAtIndex:index];
    NSString *displayName;
    [url getResourceValue:&displayName forKey:NSURLLocalizedNameKey error:nil];
    return displayName;
}

// -------------------------------------------------------------------------------
//  iconForDocumentAtIndex:index
// -------------------------------------------------------------------------------
#if TARGET_OS_IPHONE
- (UIImage *)
#else
- (NSImage *)
#endif
    iconForDocumentAtIndex:(NSInteger)index
{
    NSURL *itemURL = [self urlForDocumentAtIndex:index];
    
#if TARGET_OS_IPHONE
    // note: we use UIDocumentInteractionController to obtain the document's icon, since NSURLEffectiveIconKey does not function in iOS
    UIImage *icon = nil;
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:itemURL];
    icon = controller.icons[0];
#else
    NSImage *icon = nil;
    [itemURL getResourceValue:&icon forKey:NSURLEffectiveIconKey error:nil];
#endif
    
    return icon;
}

// -------------------------------------------------------------------------------
//  thumbNailForDocumentAtIndex:index
// -------------------------------------------------------------------------------
#if TARGET_OS_IPHONE
- (UIImage *)
#else
- (NSImage *)
#endif
    thumbNailForDocumentAtIndex:(NSInteger)index
{
    NSURL *url = [self urlForDocumentAtIndex:index];
    
#if TARGET_OS_IPHONE
    __block UIImage *thumbNailImage = nil;
#else
    __block NSImage *thumbNailImage = nil;
#endif
    
    NSError *error;
    NSDictionary *promisedImageDict;
    NSMetadataItem *item = self.sortedResults[index];
    
    NSString *downloadStatus = [item valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
    if (downloadStatus != nil)
    {
        // note we use "getPromisedItemResourceValue" to make the retrieval work for
        // ubiquitous documents that are not yet locally downloaded
        //
        [url startAccessingSecurityScopedResource];
        if ([self documentIsDownloadedAtIndex:index])
        {
            [url getResourceValue:&promisedImageDict forKey:NSURLThumbnailDictionaryKey error:&error];
        }
        else
        {
            [url getPromisedItemResourceValue:&promisedImageDict forKey:NSURLThumbnailDictionaryKey error:&error];
        }
        [url stopAccessingSecurityScopedResource];
    }

    if (promisedImageDict != nil && error == nil)
    {
        thumbNailImage = promisedImageDict[NSThumbnail1024x1024SizeKey];
    }
    
    return thumbNailImage;
}

// -------------------------------------------------------------------------------
//  modDateForDocumentAtIndex:index
// -------------------------------------------------------------------------------
- (NSDate *)modDateForDocumentAtIndex:(NSInteger)index
{
    NSDate *modDate = nil;
    NSURL *url = [self urlForDocumentAtIndex:index];
    [url getResourceValue:&modDate forKey:NSURLContentModificationDateKey error:nil];
    return modDate;
}

// -------------------------------------------------------------------------------
//  identifierForDocumentAtIndex:index
// -------------------------------------------------------------------------------
- (NSInteger)identifierForDocumentAtIndex:(NSInteger)index
{
    id docIdentifier;
    NSURL *url = [self urlForDocumentAtIndex:index];
    [url getResourceValue:&docIdentifier forKey:NSURLDocumentIdentifierKey error:nil];
    return [docIdentifier integerValue];
}

// -------------------------------------------------------------------------------
//  documentIsUploadedAtIndex:index
//
//  Get uploaded state: true if there is data present in the cloud for this item.
// -------------------------------------------------------------------------------
- (BOOL)documentIsUploadedAtIndex:(NSInteger)index
{
    NSURL *url = [self urlForDocumentAtIndex:index];
    
    NSNumber *isUploaded = nil;
    [url getResourceValue:&isUploaded forKey:NSMetadataUbiquitousItemIsUploadedKey error:nil];
    return isUploaded.boolValue;
}

// -------------------------------------------------------------------------------
//  documentIsDownloadedAtIndex:index
//
//  Get downloaded state: true if there is data present locally for this item.
// -------------------------------------------------------------------------------
- (BOOL)documentIsDownloadedAtIndex:(NSInteger)index
{
    BOOL downloaded = NO;
    
    NSMetadataItem *item = self.sortedResults[index];
    NSString *statusKey = [item valueForAttribute:NSMetadataUbiquitousItemDownloadingStatusKey];
    if (statusKey != nil)
    {
        downloaded = ![statusKey isEqualToString:NSMetadataUbiquitousItemDownloadingStatusNotDownloaded];
    }
    
    return downloaded;
}

@end
