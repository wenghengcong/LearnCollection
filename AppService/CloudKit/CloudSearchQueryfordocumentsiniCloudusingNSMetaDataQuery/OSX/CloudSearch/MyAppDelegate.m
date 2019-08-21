/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application delegate class used for copying cloud documents.
 */

@import Cocoa;

#import "MyAppDelegate.h"
#import "MyViewController.h"

#pragma mark -

@interface MyAppDelegate ()

@property (nonatomic, strong) NSURL *ubiquityContainer;
@property (nonatomic, strong) NSArray *documents;

@end


#pragma mark -

@implementation MyAppDelegate

// -------------------------------------------------------------------------------
//  ubiquityDocumentsFolder
//
//  Return the Documents folder location in iCloud.
// -------------------------------------------------------------------------------
- (NSURL *)ubiquityDocumentsFolder
{
    return [self.ubiquityContainer URLByAppendingPathComponent:@"Documents" isDirectory:YES];
}

// -------------------------------------------------------------------------------
//  applicationDidFinishLaunching:notification
// -------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // do this asynchronously since if this is the first time this particular device
    // is syncing with preexisting iCloud content it may take a long time to download
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // remember our ubiquity container NSURL for later use
        _ubiquityContainer = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        // back on the main thread, setup the cloud documents controller which queries
        // the cloud and manages our list of cloud documents:
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.ubiquityContainer != nil)
            {
                // we are connected to iCloud, proceed to copy our documents to the cloud
                _documents = @[@"Text Document1.txt",
                               @"Text Document2.txt",
                               @"Text Document3.txt",
                               @"Text Document4.rtf",
                               @"Image Document.jpg",
                               @"PDF Document.pdf",
                               @"HTML Document.html",
                               @"Video.m4v"];
                
                [self copyDefaultDocumentsToCloud];
            }
            else
            {
                NSAlert *warningAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Not_Logged_In", nil)
                                                        defaultButton:NSLocalizedString(@"OK_Button_Title", nil)
                                                      alternateButton:nil
                                                          otherButton:nil
                                            informativeTextWithFormat:NSLocalizedString(@"Not_Logged_In_Explain", nil)];
                warningAlert.alertStyle = NSWarningAlertStyle;
                [warningAlert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:nil];
            }
        });
    });
}

// -------------------------------------------------------------------------------
//	applicationShouldTerminateAfterLastWindowClosed:sender
//
//	NSApplication delegate method placed here so the sample conveniently quits
//	after we close the window.
// -------------------------------------------------------------------------------
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

// -------------------------------------------------------------------------------
//	copyDefaultDocumentsToCloud
// -------------------------------------------------------------------------------
- (void)copyDefaultDocumentsToCloud
{
    // the caller makes sure the ubiquityContainer is not nil
    assert(self.ubiquityContainer != nil);

    NSMetadataQuery *queryForPreloadData = [[NSMetadataQuery alloc] init];
    queryForPreloadData.predicate = [NSPredicate predicateWithFormat:@"%K like '*.*'", NSMetadataItemFSNameKey];
    queryForPreloadData.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
    
    __block __weak id observer; // Use __weak to ensure the observer is released after being removed from NC.
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSMetadataQueryDidFinishGatheringNotification
                                                                 object:queryForPreloadData
                                                                  queue:nil // Use the current queue
                                                             usingBlock:^(NSNotification *gatherNotification)
        {
            // Use queryForPreloadData so that it is held by the block
            // thus won't be released outside of the method.
            //
            [queryForPreloadData stopQuery];
            
            NSMutableArray *existingFileURLs = [queryForPreloadData.results valueForKey:NSMetadataItemURLKey];
            if (existingFileURLs.count == 0)
            {
                // no default documents found, ask user to upload them
                NSAlert *askUploadAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Ask_Upload", nil)
                                                          defaultButton:NSLocalizedString(@"OK_Button_Title", nil)
                                                        alternateButton:NSLocalizedString(@"Cancel_Button_Title", nil)
                                                            otherButton:nil
                                              informativeTextWithFormat:NSLocalizedString(@"Ask_Upload_Explain", nil)];
                askUploadAlert.alertStyle = NSCriticalAlertStyle;
                [askUploadAlert beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:^(NSInteger result) {
                    if (result == NSAlertDefaultReturn)
                    {
                        NSMutableArray *existingFileURLs = [queryForPreloadData.results valueForKey:NSMetadataItemURLKey];
                        existingFileURLs = [existingFileURLs valueForKey:@"lastPathComponent"];
                        
                        NSURL *documentsCloudDirectoryURL = [self ubiquityDocumentsFolder];
                        for (NSString *documentName in self.documents)
                        {
                            if (![existingFileURLs containsObject:documentName])
                            {
                                [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:documentName]
                                                                        toPath:[documentsCloudDirectoryURL.path stringByAppendingPathComponent:documentName]
                                                                         error:nil];
                            }
                        }
                        
                        // since the copy operation occurred, we need to tell our table view to rescan for documents
                        NSWindow *mainWindow = [NSApplication sharedApplication].windows[0];
                        MyViewController *viewController = (MyViewController *)mainWindow.contentViewController;
                        [viewController rescanForDocuments];
                    }
                }];
                
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
            }
        }];
    
    [queryForPreloadData startQuery];
}

@end
