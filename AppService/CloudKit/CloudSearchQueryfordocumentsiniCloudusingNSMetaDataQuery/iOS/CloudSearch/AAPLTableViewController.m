/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller for displaying iCloud documents.
 */

#import "AAPLTableViewController.h"
#import "AAPLCloudDocumentsController.h"
#import "AAPLFilterViewController.h"

enum FilterTableItems
{
    kTXTItem = 0,
    kJPGItem,
    kPDFItem,
    kHTMLItem,
    kVideoItem,
    kNoneItem
};

@interface AAPLTableViewController () <AAPLCloudDocumentsControllerDelegate, AAPLFilterViewControllerDelegate>

@property (nonatomic, strong) id ubiquityToken;
@property (nonatomic, strong) NSURL *ubiquityContainer;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSIndexPath *currentExtension;

@property (nonatomic, weak) IBOutlet UIView *switchView;
@property (nonatomic, weak) IBOutlet UISwitch *thumbSwitch;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end


#pragma mark -

@implementation AAPLTableViewController

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
                    //
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:NSLocalizedString(@"Search_Failed", nil)
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK_Button_Title", nil)
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alert addAction:OKAction];
                    
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
    if (self.activityIndicator == nil)
    {
        // create and center the activity indicator to our table
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.tableView addSubview:self.activityIndicator];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:12.0]];
    }
    
    [self.activityIndicator startAnimating];
    [[AAPLCloudDocumentsController sharedInstance] restartScan];
}

// -------------------------------------------------------------------------------
//	viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad
{
	[super viewDidLoad];
    
    // create our refresh control so users can rescan for cloud content
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switchView];
    
    // remember our login token in case the user logs out or logs in with a different account
    _ubiquityToken = [NSFileManager defaultManager].ubiquityIdentityToken;
    
    // listen for when the current ubiquity identity has changed (user logs in and out of iCloud)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ubiquityIdentityChanged:)
                                                 name:NSUbiquityIdentityDidChangeNotification
                                               object:nil];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    (self.dateFormatter).dateStyle = NSDateFormatterLongStyle;
    
    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    docsController.delegate = self;     // we need to be notified when cloud docs are found
    _currentExtension = [NSIndexPath indexPathForRow:kNoneItem inSection:0];

    // obtain our ubiquity container identifier and start the scan for documents
    [self initiateScan];
}

// -------------------------------------------------------------------------------
//	dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUbiquityIdentityDidChangeNotification
                                                  object:nil];
}

// -------------------------------------------------------------------------------
//	isLoggedIn
// -------------------------------------------------------------------------------
- (BOOL)isLoggedIn
{
    return (self.ubiquityContainer != nil);
}


#pragma mark - Actions

// -------------------------------------------------------------------------------
//	refresh:sender
//
//  Called when UIRefreshControl is pulled down from our table
// -------------------------------------------------------------------------------
- (void)refresh:(id)sender
{
    if ([self isLoggedIn])
    {
        [[AAPLCloudDocumentsController sharedInstance] restartScan];
    }
    else
    {
        [self.refreshControl endRefreshing];
    }
}

// -------------------------------------------------------------------------------
//	useThumbnail:sender
// -------------------------------------------------------------------------------
- (IBAction)useThumbnail:(id)sender
{
    if ([self isLoggedIn])
    {
        [[AAPLCloudDocumentsController sharedInstance] restartScan];
    }
}


#pragma mark - UITableViewDataSource

// -------------------------------------------------------------------------------
//	numberOfRowsInSection:section
// -------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AAPLCloudDocumentsController sharedInstance].numberOfDocuments;
}

// -------------------------------------------------------------------------------
//	cellForRowAtIndexPath:indexPath
// -------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];

    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    
    // Note:
    // Some key/values might not available right now probably because of early login state or
    // document is not fully downloaded.  So we take that into account when building our table cell.
    // We will eventually get our data when our AAPLCloudDocumentsController's NSMetaDataQuery notifies us of an update
    //
    NSString *docTitle = [docsController localizedTitleForDocumentAtIndex:indexPath.row];
    cell.textLabel.text = (docTitle != nil) ? docTitle : [[AAPLCloudDocumentsController sharedInstance] documentTitleForDocumentAtIndex:indexPath.row];

    // first we attempt to use what the UI dictates (thumbnail vs. icon)
    if (self.thumbSwitch.isOn)
    {
        UIImage *thumbnailImage = [docsController thumbNailForDocumentAtIndex:indexPath.row];
        cell.imageView.image = (thumbnailImage != nil) ? thumbnailImage : [docsController iconForDocumentAtIndex:indexPath.row];
    }
    else
    {
        // no thumbnails wanted, use the generic icon
        cell.imageView.image = [docsController iconForDocumentAtIndex:indexPath.row];
    }
    
    NSString *modDateStr = [self.dateFormatter stringFromDate:[docsController modDateForDocumentAtIndex:indexPath.row]];
    cell.detailTextLabel.text = (modDateStr != nil) ? modDateStr : @"-";

    NSString *downloadedStateStr = [docsController documentIsDownloadedAtIndex:indexPath.row] ? @"Downloaded\nYes" : @"DownLoaded\nNo";
    UILabel *downloadStateLabel = [[UILabel alloc] init];
    downloadStateLabel.font = [UIFont systemFontOfSize:9.0];
    downloadStateLabel.text = downloadedStateStr;
    downloadStateLabel.numberOfLines = 2;
    downloadStateLabel.textAlignment = NSTextAlignmentCenter;
    [downloadStateLabel sizeToFit];
    cell.accessoryView = downloadStateLabel;
    
    return cell;
}


#pragma mark - CloudDocumentsControllerDelegate

// -------------------------------------------------------------------------------
//	didRetrieveCloudDocuments
// -------------------------------------------------------------------------------
- (void)didRetrieveCloudDocuments
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    // we have stopped looking for documents, stop progress
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

// -------------------------------------------------------------------------------
//	didRetrieveCloudDocuments
// -------------------------------------------------------------------------------
- (void)didStartRetrievingCloudDocuments
{
    // we are looking for documents, show progress
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// -------------------------------------------------------------------------------
//	prepareForSegue:Sender
// -------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // setup ourselves as delegate to "didSelectExtension" will be called
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    AAPLFilterViewController *filterViewController = (AAPLFilterViewController *)navController.visibleViewController;
    filterViewController.filterDelegate = self;
    filterViewController.extensionToFilter = self.currentExtension;
}


#pragma mark - AAPLFilterViewControllerDelegate

// -------------------------------------------------------------------------------
//	didSelectExtension:extension
// -------------------------------------------------------------------------------
- (void)filterViewController:(AAPLFilterViewController *)viewController didSelectExtension:(NSIndexPath *)extension
{
    _currentExtension = extension;
    
    AAPLCloudDocumentsController *docsController = [AAPLCloudDocumentsController sharedInstance];
    
    NSString *extensionToUse = nil;
    switch (extension.row)
    {
        case kTXTItem:
            extensionToUse = @"txt";
            break;
        case kJPGItem:
            extensionToUse = @"jpg";
            break;
        case kPDFItem:
            extensionToUse = @"pdf";
            break;
        case kHTMLItem:
            extensionToUse = @"html";
            break;
        case kVideoItem:
            extensionToUse = @"m4v";
            break;
        case kNoneItem:
            extensionToUse = @"";
            break;
    }
    
    docsController.fileType = extensionToUse;
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
        // present an error to say that it wasn't possible to start the iCloud query
        //
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Logged_Out_Message", nil)
                                                                       message:NSLocalizedString(@"Logged_Out_Message_Explain", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK_Button_Title", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:OKAction];
        [self.navigationController presentViewController:alert animated:YES completion:nil];

        _ubiquityContainer = nil;   // no more container to point to
        
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

@end

