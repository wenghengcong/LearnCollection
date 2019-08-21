/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Primary view controller for this sample, used to display search results.
 */

#import "MyViewController.h"
#import "AAPLCloudDocumentsController.h"

// filter NSPopUpButton menu item indexes:
enum FilterMenuItems
{
    kTXTItem = 0,
    kJPGItem,
    kPDFItem,
    kHTMLItem,
    kVideoItem,
    kNoneItem = 6
};

@interface MyViewController () < NSTableViewDelegate, NSTableViewDataSource, AAPLCloudDocumentsControllerDelegate>

@property (nonatomic, strong) NSURL *ubiquityContainer;
@property (nonatomic, strong) id ubiquityToken;

@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSPopUpButton *filterPopup;
@property (nonatomic, strong) IBOutlet NSButton *useThumbNailsCheckbox;
@property (nonatomic, strong) IBOutlet NSProgressIndicator *progIndicator;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


#pragma mark -

@implementation MyViewController

// -------------------------------------------------------------------------------
//  initiateScan
// -------------------------------------------------------------------------------
- (void)initiateScan
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // remember our ubiquity container NSURL for later use
        _ubiquityContainer = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // we are connected to iCloud, start scanning for documents
            if ([self isLoggedIn])
            {
                if (![[AAPLCloudDocumentsController sharedInstance] startScanning])
                {
                    // present an error to say that it wasn't possible to start the iCloud query
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Search_Failed", nil)};
                    NSError *error = [[NSError alloc] initWithDomain:@"Application" code:200 userInfo:userInfo];
                    [NSApp presentError:error];
                }
            }
        });
    });
}

// -------------------------------------------------------------------------------
//	rescanForDocuments
//
//  Called from our app delegate in case it wants to rescan for documents
//  (likely when default documents are first copied up to the cloud)
// -------------------------------------------------------------------------------
- (void)rescanForDocuments
{
    self.progIndicator.hidden = NO;
    [self.progIndicator startAnimation:self];
    [[AAPLCloudDocumentsController sharedInstance] restartScan];
}

// -------------------------------------------------------------------------------
//  viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    _dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    
    [self.filterPopup selectItemAtIndex:kNoneItem];   // start by filtering for all files
    
    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    docsController.fileType = @"";      // start by finding all files
    docsController.delegate = self;     // we need to be notified when cloud docs are found
    
    // listen for when the current ubiquity identity has changed (user logs out and in as a different user)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ubiquityIdentityChanged:)
                                                 name:NSUbiquityIdentityDidChangeNotification
                                               object:nil];
    
    // obtain our ubiquity container identifier and start the scan for documents
    [self initiateScan];
}

// -------------------------------------------------------------------------------
//	dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquityIdentityDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidBecomeActiveNotification object:nil];
}

// -------------------------------------------------------------------------------
//	isLoggedIn
// -------------------------------------------------------------------------------
- (BOOL)isLoggedIn
{
    return (self.ubiquityContainer != nil);
}


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [AAPLCloudDocumentsController sharedInstance].numberOfDocuments;
}

// -------------------------------------------------------------------------------
//	viewForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // In IB the tableColumn has the identifier set to the same string as the keys in our dictionary
    NSString *identifier = tableColumn.identifier;
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    
    // Note:
    // Some key/values might not available right now probaby because of early login
    // state or document is not fully downloaded.  So we take that into account when building our table cell.
    // We will eventually get our data when our AAPLCloudDocumentsController's NSMetaDataQuery notifies us of an update
    //
    
    // check the column identifier to decide how to setup the cell view
    if ([identifier isEqualToString:@"itemName"])
    {
        NSString *docTitle = [docsController localizedTitleForDocumentAtIndex:row];
        cellView.textField.stringValue = (docTitle != nil) ? docTitle : [docsController documentTitleForDocumentAtIndex:row];

        // first we attempt to use what the UI dictates (thumbnail vs. icon)
        if (self.useThumbNailsCheckbox.state)
        {
            NSImage *thumbNailImage = [docsController thumbNailForDocumentAtIndex:row];
            cellView.imageView.image = (thumbNailImage != nil) ? thumbNailImage : [docsController iconForDocumentAtIndex:row];
        }
        else
        {
            // no thumbnails wanted, use the generic icon
            cellView.imageView.image = [docsController iconForDocumentAtIndex:row];
        }
    }
    else if ([identifier isEqualToString:@"itemModDate"])
    {
        NSString *modDateStr = [self.dateFormatter stringFromDate:[docsController modDateForDocumentAtIndex:row]];
        cellView.textField.stringValue = (modDateStr != nil) ? modDateStr : @"-";
    }
    else if ([identifier isEqualToString:@"itemDownloaded"])
    {
        cellView.textField.stringValue =
            [docsController documentIsDownloadedAtIndex:row] ? NSLocalizedString(@"Downloaded", nil) : NSLocalizedString(@"Not_Downloaded", nil);
    }
    
    return cellView;
}


#pragma mark - NSTableViewDelegate

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:aTableColumn:rowIndex
// -------------------------------------------------------------------------------
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return NO;
}

// -------------------------------------------------------------------------------
//	shouldSelectRow:row
// -------------------------------------------------------------------------------
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}


#pragma mark - Actions

// -------------------------------------------------------------------------------
//	refreshAction:sender
// -------------------------------------------------------------------------------
- (IBAction)refreshAction:(id)sender
{
   if ([self isLoggedIn])
   {
       [[AAPLCloudDocumentsController sharedInstance] restartScan];
   }
}

// -------------------------------------------------------------------------------
//	useThumbnailsAction:sender
//
//  User chose to turn on or off thumbnails for the item's icon
// -------------------------------------------------------------------------------
- (IBAction)useThumbnailsAction:(id)sender
{
    if ([self isLoggedIn])
    {
        [[AAPLCloudDocumentsController sharedInstance] restartScan];
    }
}

// -------------------------------------------------------------------------------
//	filterAction:sender
//
//  User chose an extension to filter the search.
// -------------------------------------------------------------------------------
- (IBAction)filterAction:(id)sender
{
    NSPopUpButton *popupButton = sender;
    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    
    NSString *fileType = nil;
    switch (popupButton.indexOfSelectedItem)
    {
        case kTXTItem:
            fileType = @"txt";
            break;
        case kJPGItem:
            fileType = @"jpg";
            break;
        case kPDFItem:
            fileType = @"pdf";
            break;
        case kHTMLItem:
            fileType = @"html";
            break;
        case kVideoItem:
            fileType = @"m4v";
            break;
        case kNoneItem:
            fileType = @"";
            break;
    }
    
    docsController.fileType = fileType;
    if ([self isLoggedIn])
    {
        [docsController restartScan];
    }
}


#pragma mark - Notifications

//----------------------------------------------------------------------------------------
// ubiquityIdentityChanged
//
// Notification that the user has either logged in our out of iCloud.
//----------------------------------------------------------------------------------------
- (void)ubiquityIdentityChanged:(NSNotification *)note
{
    id token = [NSFileManager defaultManager].ubiquityIdentityToken;
    if (token == nil)
    {
        NSAlert *warningAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Logged_Out_Message", nil)
                                                defaultButton:NSLocalizedString(@"OK_Button_Title", nil)
                                              alternateButton:nil
                                                  otherButton:nil
                                    informativeTextWithFormat:NSLocalizedString(@"Logged_Out_Message_Explain", nil)];
        warningAlert.alertStyle = NSWarningAlertStyle;
        [warningAlert beginSheetModalForWindow:self.view.window completionHandler:nil];
        
        _ubiquityContainer = nil;   // no more container to point to
        
        // we are logged out so clear our window and stop the Spotlight search
        [[AAPLCloudDocumentsController sharedInstance] stopScanning];
        
        [self.tableView reloadData];
    }
    else
    {
        if ([self.ubiquityToken isEqual:token])
        {
            NSLog(@"user has stayed logged in with same account");
        }
        else
        {
            // user logged in with a different account
            NSLog(@"user logged in with a new account");
        }
        
        // store off this token to compare later
        self.ubiquityToken = token;
        
        // re-obtain our ubiquity container identifier and start the scan for documents
        [self initiateScan];
    }
}


#pragma mark - AAPLCloudDocumentsControllerDelegate

// -------------------------------------------------------------------------------
//	didRetrieveCloudDocuments
// -------------------------------------------------------------------------------
- (void)didRetrieveCloudDocuments
{
    [self.tableView reloadData];
    
    // we have finished looking for documents, stop progress animation
    [self.progIndicator stopAnimation:self];
}

// -------------------------------------------------------------------------------
//	didRetrieveCloudDocuments
// -------------------------------------------------------------------------------
- (void)didStartRetrievingCloudDocuments
{
    // we are looking for documents, show progress animation
    [self.progIndicator startAnimation:self];
}

@end
