/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class used to keep track of known documents in the cloud.
 */

@import Foundation;

#if TARGET_OS_IPHONE
@import UIKit;
#endif

@import Foundation;

@protocol AAPLCloudDocumentsControllerDelegate;

@interface AAPLCloudDocumentsController : NSObject

@property (readonly) NSUInteger numberOfDocuments;
@property (nonatomic, weak, readwrite) id <AAPLCloudDocumentsControllerDelegate> delegate;
@property (nonatomic, strong) NSString *fileType;

+ (AAPLCloudDocumentsController *)sharedInstance;

- (instancetype)initWithType:(NSString *)fileType NS_DESIGNATED_INITIALIZER;

- (BOOL)startScanning;
- (void)stopScanning;
- (void)restartScan;    // stop the scan and restart it again
- (void)removeQuery;     // release our query and remove all observers

// obtaining information about a cloud document
- (NSURL *)urlForDocumentAtIndex:(NSInteger)index;
- (NSString *)documentTitleForDocumentAtIndex:(NSInteger)index;
- (NSString *)localizedTitleForDocumentAtIndex:(NSInteger)index;

#if TARGET_OS_IPHONE
- (UIImage *)iconForDocumentAtIndex:(NSInteger)index;
- (UIImage *)thumbNailForDocumentAtIndex:(NSInteger)index;
#else
- (NSImage *)iconForDocumentAtIndex:(NSInteger)index;
- (NSImage *)thumbNailForDocumentAtIndex:(NSInteger)index;
#endif

- (NSDate *)modDateForDocumentAtIndex:(NSInteger)index;
- (BOOL)documentIsUploadedAtIndex:(NSInteger)index;
- (BOOL)documentIsDownloadedAtIndex:(NSInteger)index;
- (NSInteger)identifierForDocumentAtIndex:(NSInteger)index;

@end


#pragma mark -

@protocol AAPLCloudDocumentsControllerDelegate <NSObject>
@required
- (void)didRetrieveCloudDocuments;          // notify delegate when cloud documents are found
- (void)didStartRetrievingCloudDocuments;   // notify delegate when starting search of cloud documents  
@end