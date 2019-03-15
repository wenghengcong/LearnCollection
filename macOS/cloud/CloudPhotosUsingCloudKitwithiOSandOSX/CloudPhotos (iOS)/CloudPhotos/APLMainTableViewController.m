/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's primary table view controller showing the list of photos.
 */

#import "APLMainTableViewController.h"
#import "AppDelegate.h"
#import "APLDetailTableViewController.h"
#import "APLCloudManager.h"
#import "PhotoTableCell.h"
#import "CloudPhoto.h"

@import CloudKit;
@import CoreLocation;   // for tracking user's location and CLGeocoder
@import Photos;

static NSString * const kCellIdentifier = @"cellID";

typedef NS_ENUM(NSInteger, ScopeIndexes) {
    kAllScope = 0,
    kMineScope,
    kRecentScope,
    kNearMeScope
};

#define kRecentDays 5   // number of days we consider a photo to be recent


#pragma mark -

@interface APLMainTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *photos;   // all photos

@property (nonatomic, strong) NSMutableArray *searchedPhotos;  // all photos found based on the search bar's scope
@property (nonatomic, strong) NSArray *filteredPhotos;  // photos currently being filtered in and out while typing in the search bar

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *addButton;

// no photos label and its constraints, added to the table if no photos are present
@property (nonatomic, strong) UILabel *noPhotosLabel;
@property (nonatomic, strong) NSLayoutConstraint *labelConstraintForX;
@property (nonatomic, strong) NSLayoutConstraint *labelConstraintForY;

@property (assign) BOOL wasResumed; // keep track when we were re-activated from the background

// for state restoration
@property BOOL restoringSearchState;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (nonatomic, strong) NSString *searchControllerText;
@property (assign) NSInteger searchControllerScopeIndex;

@property BOOL searchControllerActiveFromPreviousView;

// for tracking user location
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end


#pragma mark -

@implementation APLMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = nil;    // we aren't yet ready to populate our photo list
    
    _geocoder = [[CLGeocoder alloc] init];  // so we can show the user the city and state a given photo was taken
    
    // location services
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestWhenInUseAuthorization];   // ask for user permission to find our location, we use this to find photos near us
    }
    
    // setup our search display controller for searching photos
    //
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;

    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    // create our refresh control so users can rescan for photos
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // while in table edit mode, we allow for "Delete My Photos" feature in the bottom toolbar
    UIBarButtonItem *clearAllButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete My Photos", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(deleteAllAction:)];
    [self setToolbarItems:@[clearAllButton] animated:NO];
    
    // listen when we are backgrounded (leaving the app)
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      // we are being backgrounded, exit edit mode in our table
                                                      if (self.isEditing)
                                                      {
                                                          [self setEditing:NO animated:NO];
                                                      }
                                                  }];
  
    // listen when we are activated (resuming the app)
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      _wasResumed = YES;
                                                  }];
    
    // listen for updates due to push notification processing, so we can update our UI
    [[NSNotificationCenter defaultCenter] addObserverForName:[APLCloudManager UpdateContentWithNotification]
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      
                                                      // a push notification (CKQueryNotification) has arrived,
                                                      // update our table for added, removed or updates photos
                                                      //
                                                      CKQueryNotification *queryNotification = notification.object;
                                                      CKQueryNotificationReason reason = queryNotification.queryNotificationReason;
                                                      CKRecordID *recordID = queryNotification.recordID;

                                                      // a photo has come in that was added, deleted or updated:
                                                      // update just the table cell this CKRecord is associated with,
                                                      // instead of just doing an entire table re-fetch, let's be efficient and just apply the update for the photo in question
                                                      //
                                                      [self updateTableWithRecordID:recordID reason:reason];
                                                  }];
    
    // initially add our right Edit button as disabled
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.enabled = NO;
    
    // create a custom navigation bar button and clear it's title (so it's only a back arrow)
    // we do this to allow for more room for the photo title in the center
    //
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
    // then search for photos
    [self refresh:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive)
    {
        // filtering the list of photos isn't possible yet until our fetch completes in "loadPhotos",
        // so filter the table after the fetch completes with this flag
        //
        _restoringSearchState = YES;
        
        // restore our search controller using state restoration
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;    // reset this state for next time
        
        self.searchController.searchBar.text = self.searchControllerText;

        // only restore scopes except "near me", because we may not have the user's location captured yet
        self.searchController.searchBar.selectedScopeButtonIndex = self.searchControllerScopeIndex;
        
        if (self.searchControllerSearchFieldWasFirstResponder)
        {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO; // reset this state for next time
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[APLCloudManager UpdateContentWithNotification]
                                                  object:nil];
}


#pragma mark - UI Methods

// update our navigation bar so that the edit and add button states are correct according to user login
- (void)updateNavigationBar
{
    [CloudManager cloudServiceAvailable:^(BOOL available) {
        if ([CloudManager accountAvailable] && [CloudManager userLoginIsValid])
        {
            // we are logged in, iCloud drive is on
            
            // the edit button state should update
            self.editButtonItem.enabled = (self.photos.count > 0);
            
            // add button state should match if we have a container to read/write to
            self.addButton.enabled = YES;
        }
        else
        {
            // we are not logged into iCloud
            // or
            // we are logged into iCloud, but iCloud drive is turned off
            //
            // we can just read but can't make any changes
            
            // note: in simulator for iOS 7 or earlier, for accountStatus you get: "CKAccountStatusNoAccount"
            
            // disable the edit and add button
            self.editButtonItem.enabled = self.addButton.enabled = NO;
        }
    }];
}

// obtain the index row number of the given recordID, -1 if it cannot be found
- (NSInteger)indexForPhotoWithRecordID:(CKRecordID *)recordID
{
    NSInteger foundIndex = -1;
    
    for (NSUInteger rowIdx = 0; rowIdx < self.photos.count; rowIdx++)
    {
        CloudPhoto *photo = self.photos[rowIdx];
        if ([photo.cloudRecord.recordID isEqual:recordID])
        {
            foundIndex = rowIdx;
            break;  // we found the photo that needs updating, no need to continue searching
        }
    }
    
    return foundIndex;
}

// called as a result of a subscription notification:
// update just the table cell this CKRecordID is associated with,
// instead of just doing an entire table re-fetch, let's be efficient and just apply the update for the photo in question
//
- (void)updateTableWithRecordID:(CKRecordID *)recordID reason:(CKQueryNotificationReason)reason
{
    if (reason == CKQueryNotificationReasonRecordDeleted)
    {
        // we are being asked to remove an existing photo
        NSInteger photoIndex = [self indexForPhotoWithRecordID:recordID];
        if (photoIndex != -1)
        {
            // we found a proper photo in our table view to be removed
            CloudPhoto *foundPhoto = self.photos[photoIndex];
            
            // photo was removed, remove it from the table
            if (foundPhoto != nil)
            {
                // we found the photo that needs removing
                [self.photos removeObject:foundPhoto];
                
                // update our table
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:photoIndex inSection:0];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
        }
    }
    else
    {
        // we are being told a photo was added or updated
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // first we need to fetch that photo
        [CloudManager fetchRecordWithID:recordID completionHandler:^(CKRecord *foundRecord, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            if (foundRecord != nil)
            {
                // we have obtained the photo to be added or updated
                //
                NSInteger photoIndex = [self indexForPhotoWithRecordID:recordID];
                
                if (reason == CKQueryNotificationReasonRecordUpdated)
                {
                    if (photoIndex >= 0)
                    {
                        // we found the photo that needs "updating"
                        //
                        CloudPhoto *photoToReplace = [[CloudPhoto alloc] initWithRecord:foundRecord];
                        [self.photos replaceObjectAtIndex:photoIndex withObject:photoToReplace];
                        
                        // update the cell with the new photo data
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:photoIndex inSection:0];
                        
                        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        ((PhotoTableCell *)cell).photo = photoToReplace;
                        
                        // resort the list of photos, but keep track of its indexPath so we can move its table cell into the right place
                        NSInteger oldIndexForPhoto = [self indexForPhotoWithRecordID:recordID];
                        NSInteger newIndexForPhoto = [self indexForPhotoWithRecordID:recordID];
                        
                        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndexForPhoto inSection:0];
                        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndexForPhoto inSection:0];
                        [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
                        
                        // update the photo cell
                        [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
                        
                        NSSortDescriptor *sortDescriptor =
                        [NSSortDescriptor sortDescriptorWithKey:[APLCloudManager PhotoTitleAttribute] ascending:YES];
                        [self.photos sortUsingDescriptors:@[sortDescriptor]];
                    }
                }
                else if (reason == CKQueryNotificationReasonRecordCreated)
                {
                    if (photoIndex == -1)   // make sure the photo isn't already in the list
                    {
                        // no photos were found on our list, so add this new one
                        CloudPhoto *photoToAdd = [[CloudPhoto alloc] initWithRecord:foundRecord];
                        [self.photos addObject:photoToAdd];
                        
                        // update our table
                        NSInteger newIndexForPhoto = [self indexForPhotoWithRecordID:recordID];
                        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndexForPhoto inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        // resort the list of photos
                        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[APLCloudManager PhotoTitleAttribute] ascending:YES];
                        [self.photos sortUsingDescriptors:@[sortDescriptor]];
                    }
                }
                
                [self.tableView reloadData];
                
                // update the edit button state (in case we had no photos before)
                self.editButtonItem.enabled = (self.photos.count > 0);
            }
        }];
    }
}


#pragma mark - Photo Management

- (void)loginUpdate
{
    // the user has signed in or out of iCloud, so we need to refresh our UI reflect user login
    //
    // re-load all the photos
    [self refresh:self]; // refresh/reload our table
}

// the primary search method for this app
//
- (void)loadPhotos:(void (^)(void))completionHandler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [CloudManager fetchRecords:^(NSArray *foundPhotos, NSError *error) {

        // done loading
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        self.tableView.dataSource = self;   // now that we have data, we can start populating our table
        
        if (error != nil)
        {
            if (error.code == CKErrorLimitExceeded)
            {
                // the request to the server was too large. Retry this request as a smaller batch
            }
            else if (error.code == CKErrorServerRejectedRequest)
            {
                // service or server problems (may be because the record type
                // is not defined in the schema yet or the schema was removed from CloudKit Dashboard)
                //
            }
            else if (error.code != CKErrorUnknownItem)
            {
                // note we can get CKErrorUnknownItem for the first time the app is open
                // (no records added to that container yet, no schema defined)
                //
            }
            
            // On CKErrorServiceUnavailable or CKErrorRequestRateLimited errors:
            // the userInfo dictionary may contain a NSNumber instance that specifies the period of time in seconds after
            // which the client may retry the request.  So here we will try again.
            //
            if (error.code == CKErrorServiceUnavailable || error.code == CKErrorRequestRateLimited)
            {
                NSNumber *retryAfter = error.userInfo[CKErrorRetryAfterKey] ? : @3; // try again after 3 seconds if we don't have a retry hint
                NSLog(@"Error: %@. Recoverable, retry after %@ seconds", [error description], retryAfter);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryAfter.intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadPhotos:completionHandler];
                });
            }
            else
            {
                // due to an error, no photos should be shown
                _photos = nil;
                [self.tableView reloadData];
            }
        }
        else
        {
            // all is good, we get back an array of photos
            //NSLog(@"found %ld photos", (long)records.count);
            
            _photos = [NSMutableArray array];
            // all is good, as we get back an array of CKRecords, convert them to CloudPhoto objects
            for (CKRecord *record in foundPhotos)
            {
                [self.photos addObject:[[CloudPhoto alloc] initWithRecord:record]];
            }
            [self.tableView reloadData];
            
            if (self.restoringSearchState)
            {
                // we are trying to restore state when our app was relaunched (UIStateRestoration)
                // so we must start our search filtering
                _restoringSearchState = NO;
                
                [self updateSearchResultsForSearchController:self.searchController];
            }
        }
        
        // edit button should be disabled if there are no photos
        self.editButtonItem.enabled = (self.photos.count > 0);
        
        if (completionHandler != nil)
        {
            completionHandler();    // invoke our caller's completion handler indicating we are done
        }
    }];
}

// used by 'updateSearchResultsForSearchController'
// called when user choose a different search scope in the search bar
//
- (void)finishPhotoFilteringByTitle:(NSString *)title photos:(NSArray *)photosToFilter
{
    NSArray *newlyFilteredPhotos = [photosToFilter copy];
    
    // filter list further down by photo title
    if (title.length > 0)
    {
        // if we have search text, filter down the results further
        NSPredicate *titleSearchPredicate =
            [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", [APLCloudManager PhotoTitleAttribute], title]; // [cd] = case insensitive
        
        newlyFilteredPhotos = [photosToFilter filteredArrayUsingPredicate:titleSearchPredicate];
    }
    
    self.filteredPhotos = newlyFilteredPhotos;
    [self.tableView reloadData];
}

- (void)searchAll
{
    // search for all photos
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self loadPhotos:^() {
        
        // done fetching, filter the photos further by photo title
        _searchedPhotos = self.photos;
        
        [self finishPhotoFilteringByTitle:self.searchController.searchBar.text photos:self.searchedPhotos];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)searchMine
{
    [CloudManager fetchLoggedInUserRecord:^(CKRecordID *loggedInUserRecordID) {
        
        // note we may get back a nil user record ID if the user is logged out of iCloud
        if (loggedInUserRecordID != nil)
        {
            // we are logged in, so start the search
            CKRecordID *ourLoggedInRecordID = [[CKRecordID alloc] initWithRecordName:loggedInUserRecordID.recordName];
            NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"creatorUserRecordID", ourLoggedInRecordID];
            
            [CloudManager fetchRecordsWithPredicate:searchPredicate completionHandler:^(NSArray *foundRecords, NSError *error) {
                // done fetching
                //
                
                // all is good, as we get back an array of CKRecords, convert them to CloudPhoto objects
                _searchedPhotos = [NSMutableArray array];
                for (CKRecord *record in foundRecords)
                {
                    [self.searchedPhotos addObject:[[CloudPhoto alloc] initWithRecord:record]];
                }
                
                // filter the photos further by photo title
                [self finishPhotoFilteringByTitle:self.searchController.searchBar.text photos:self.searchedPhotos];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
    }];
}

- (void)searchRecent
{
    // fetch for all recent records whose photo asset was created within the last number of "days" as input
    //
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDate *now = [NSDate date];
    NSTimeInterval secondsForDays = kRecentDays * 24 * 60 * 60;   // recent is 5 days
    NSDate *lastDate = [NSDate dateWithTimeInterval:-secondsForDays sinceDate:now];
    
    NSPredicate *startDatePredicate = [NSPredicate predicateWithFormat:@"%K >= %@", [APLCloudManager PhotoDateAttribute], lastDate];
    NSPredicate *endDatePredicate = [NSPredicate predicateWithFormat:@"%K <= %@", [APLCloudManager PhotoDateAttribute], now];
    NSCompoundPredicate *recentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[startDatePredicate, endDatePredicate]];
    
    [CloudManager fetchRecordsWithPredicate:recentPredicate completionHandler:^(NSArray *foundRecords, NSError *error) {
        
        // done fetching
        //
        // all is good, as we get back an array of CKRecords, convert them to CloudPhoto objects
        _searchedPhotos = [NSMutableArray array];
        for (CKRecord *record in foundRecords)
        {
            [self.searchedPhotos addObject:[[CloudPhoto alloc] initWithRecord:record]];
        }
        
        // filter the photos further photo title
        [self finishPhotoFilteringByTitle:self.searchController.searchBar.text photos:self.searchedPhotos];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)searchNearMe
{
    // fetch for all records within a "kNearMeDistance" kilometer radius of the user's location
    //
    // we might not have our user location yet
    if (self.currentLocation != nil)
    {
        // for this scope to work, we "should" have the user's location by now
        //
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSPredicate *locationSearchPredicate =
            [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(PhotoLocation, %@) < %f", self.currentLocation, kNearMeDistance];
        
        [CloudManager fetchRecordsWithPredicate:locationSearchPredicate completionHandler:^(NSArray *foundRecords, NSError *error) {
            
            // done fetching
            //
            // all is good, as we get back an array of CKRecords, convert them to CloudPhoto objects
            _searchedPhotos = [NSMutableArray array];
            for (CKRecord *record in foundRecords)
            {
                [self.searchedPhotos addObject:[[CloudPhoto alloc] initWithRecord:record]];
            }
            
            // filter the photos further by kPhotoTitle attribute
            [self finishPhotoFilteringByTitle:self.searchController.searchBar.text photos:self.searchedPhotos];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}


#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (!editing)
    {
        // reset the navigation bar if we exit edit mode
        [self updateNavigationBar];
    }
    else
    {
        // disable the add button while in edit mode
        self.addButton.enabled = NO;
    }
    
    // hide/show toolbar on edit toggle
    [self.navigationController setToolbarHidden:!editing animated:YES];
}

// called when UIRefreshControl is pulled down from our table
- (void)refresh:(id)sender
{
    self.editButtonItem.enabled = NO;    // no editing while refreshing

    [self loadPhotos:^() {
        // query completed, close out our refresh control
        [self.refreshControl endRefreshing];
        
        [CloudManager fetchLoggedInUserRecord:^(CKRecordID *userRecordID) {
            [self updateNavigationBar];
        }];
    }];
}

// called when the user decides to delete all photos
- (void)deleteAllAction:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:NSLocalizedString(@"Confirm Remove", nil)
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK Button Title", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
            // OK button action
            [CloudManager fetchLoggedInUserRecord:^(CKRecordID *loggedInUserRecordID) {
            
                // find all of our photos that we own, delete only those
                //
                __block NSMutableArray *recordIDsToDelete = [NSMutableArray arrayWithCapacity:self.photos.count];
                
                for (CloudPhoto *photo in self.photos)
                {
                    CKRecordID *userRecordID = photo.cloudRecord.creatorUserRecordID;
                    
                    if ([CloudManager isMyRecord:userRecordID])
                    {
                        // we found a deleted photo we own, add it to our removal list
                        [recordIDsToDelete addObject:photo.cloudRecord.recordID];
                    }
                }
                
                // delete all operation means we exit edit mode
                [self setEditing:NO animated:YES];
                    
                if (recordIDsToDelete.count > 0)
                {
                    // remove our photos
                    [CloudManager deleteRecordsWithIDs:recordIDsToDelete completionHandler:^(NSArray *deletedRecordIDs, NSError *error) {
                        
                        if (error != nil)
                        {
                            NSLog(@"An error occured in '%@': error[%ld] %@",
                                  NSStringFromSelector(_cmd), (long)error.code, error.localizedDescription);
                        }
                        
                        // photos are removed from the cloud, now proceed to remove our photos from our table and refresh
                        for (CKRecordID *deletedRecordID in deletedRecordIDs)
                        {
                            for (CloudPhoto *photo in self.photos)
                            {
                                if ([photo.cloudRecord.recordID isEqual:deletedRecordID])
                                {
                                    [self.photos removeObject:photo];
                                    break;
                                }
                            }
                        }
                        [self.tableView reloadData];
                        
                        // disable Edit button if we have no photos
                        self.editButtonItem.enabled = (self.photos.count > 0);
                    }];
                }
            }];
    }];
    [alert addAction:OKAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel Button Title", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UISearchBarDelegate

// called when UISearchBar's keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // all we do here is dismiss the keyboard
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    // user tapped the scope bar, toggling between: All, Mine, Recents, or Near Me, to change the search criteria
    if (self.photos.count > 0)
    {
        switch (self.searchController.searchBar.selectedScopeButtonIndex)
        {
            case kAllScope:
            {
                // search all photos
                [self searchAll];
                break;
            }
                
            case kMineScope:
            {
                // search for photos by owner (me)
                [self searchMine];
                break;
            }
                
            case kRecentScope:
            {
                // find photos created in the last 5 days
                [self searchRecent];
                break;
            }
                
            case kNearMeScope:
            {
                // we have tracked the user's location, and the user wants to search for photos for "near us"
                [self searchNearMe];
                break;
            }
        }
    }

}


#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
    _searchedPhotos = [self.photos copy];   // start our search with all photos
    
    // configure the search bar scope buttons
    NSMutableArray *scopeTitles = [NSMutableArray arrayWithArray:
                                        @[NSLocalizedString(@"All Segment Item Title", nil),
                                          NSLocalizedString(@"Owner Segment Item Title", nil),
                                          NSLocalizedString(@"Recent Segment Item Title", nil)]];
    
    // we might be called here early for state restoration, and we may not have a lock on the user's location
    // add the "Near Me" scope if we know the user's location,
    // (if not available, the scope will be added later in "didUpdateLocations")
    //
    if (self.currentLocation != nil)
    {
        // we have the user's location, allow for search "Near Me"
        [scopeTitles addObject:NSLocalizedString(@"Near Me Segment Item Title", nil)];
    }
    self.searchController.searchBar.scopeButtonTitles = scopeTitles;
    
    self.refreshControl.enabled = NO;   // no refreshing the table while filtering
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.refreshControl.enabled = YES;  // bring back refresh control
    [self.tableView reloadData];        // reset the table back since we are done searching
}


#pragma mark - UITableViewDelegate

// utility report that the user can't delete a given photo, either because they are not logged in or an error was encountered
//
- (void)reportLogoutDeleteError:(NSError *)error
{
    NSString *messageStr = nil;
    if (error == nil || ([[error domain] isEqualToString:CKErrorDomain] && (error.code == CKErrorNotAuthenticated)))
    {
        messageStr = NSLocalizedString(@"Removal alert detail message not logged in", nil);
    }
    else
    {
        messageStr = [NSString stringWithFormat:@"Error domain/code: %@, %ld", [error domain], (long)error.code];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Removal alert message not logged in", nil)
                                                                   message:messageStr
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK Button Title", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.editing = NO;  // bail out of edit mode due to error
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editingStyle = UITableViewCellEditingStyleNone;
    
    // check if the given photo is our photo, allowing us to delete it
    CloudPhoto *photoToCheck = self.photos[indexPath.row];
    CKRecordID *creatorRecordID = photoToCheck.cloudRecord.creatorUserRecordID;
    if ([CloudManager isMyRecord:creatorRecordID])
    {
        editingStyle = UITableViewCellEditingStyleDelete;
    }
    
    return editingStyle;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CloudPhoto *photoToDelete = self.photos[indexPath.row];
        
        CKRecordID *userRecordID = photoToDelete.cloudRecord.creatorUserRecordID;
        [CloudManager fetchLoggedInUserRecord:^(CKRecordID *foundUserRecordID) {
            if (foundUserRecordID == nil)
            {
                // can't find logged in user record info, alert user we are logged out and delete is not possible
                [self reportLogoutDeleteError:nil];
            }
            else if ([CloudManager isMyRecord:userRecordID])
            {
                // we own this photo, so we are allowed to delete it
                [CloudManager deleteRecordWithID:photoToDelete.cloudRecord.recordID completionHandler:^(CKRecordID *recordID, NSError *error) {
                    if (error == nil)
                    {
                        // change our table view (remove the deleted photo)
                        [self.photos removeObject:photoToDelete];
                        
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        if (self.photos.count == 0)
                        {
                            // no more photos left, exit edit mode
                            self.editing = NO;
                        }
                        
                        // check if there are any photos left in the list that belong to the current logged in user
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        
                        // we are logged in, so start the search of our photos
                        CKRecordID *ourLoggedInRecordID = [[CKRecordID alloc] initWithRecordName:foundUserRecordID.recordName];
                        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"creatorUserRecordID", ourLoggedInRecordID];
                        
                        [CloudManager fetchRecordsWithPredicate:searchPredicate completionHandler:^(NSArray *foundRecords, NSError *searchError) {
                            // done fetching
                            //
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                            if (foundRecords.count == 0)
                            {
                                // none of our photos were found, exit edit mode (no more deletions possible)
                                [self setEditing:NO animated:YES];
                            }
                            
                            // edit button should be disabled if there are no photos or no records that belong to us
                            self.editButtonItem.enabled = (self.photos.count > 0) && (foundRecords.count > 0);
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    APLDetailTableViewController *detailViewController = (APLDetailTableViewController *)segue.destinationViewController;
    
    // so we can be notified when a photo was changed by APLDetailTableViewController
    detailViewController.delegate = self;
    
    if ([segue.identifier isEqualToString:@"pushToDetail"])
    {
        if (self.searchController.isActive)
        {
            // remember our search controller state, so next time we become visible there's no need to start a re-filter again
            _searchControllerActiveFromPreviousView = YES;
        }
        
        // pass the CloudPhoto to our detail view controller
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];

        CloudPhoto *selectedPhoto =
            (self.searchController.active) ?
                self.filteredPhotos[selectedIndexPath.row] : self.photos[selectedIndexPath.row];

        detailViewController.photo = selectedPhoto;
    }
}


#pragma mark - UITableViewDataSource

// utility method returns YES if we have photos in our table, NO if no photos
- (BOOL)shouldUseNoPhotosLabel
{
    BOOL shouldUseNoPhotosLabel = NO;
    NSInteger numberOfPhotos =
        (self.searchController.active) ? self.filteredPhotos.count : self.photos.count;
    if (numberOfPhotos == 0 && !self.searchController.active)
    {
        // we need to show the "No Photos" label
        shouldUseNoPhotosLabel = YES;
    }
    return shouldUseNoPhotosLabel;
}

// show or hide the "No Photos" label centered in the table view if we have no photos to show
- (void)hideOrShowNoRecordsLabel
{
    if ([self shouldUseNoPhotosLabel])
    {
        if (self.noPhotosLabel == nil)
        {
            // add a "No Photos" label and place it centered within our table
            _noPhotosLabel = [[UILabel alloc] initWithFrame:CGRectNull];
            self.noPhotosLabel.text = NSLocalizedString(@"No Photos", nil);
            self.noPhotosLabel.font = [UIFont systemFontOfSize:18];
            [self.noPhotosLabel sizeToFit];
            self.noPhotosLabel.textColor = [UIColor lightGrayColor];
        }
        
        if (self.noPhotosLabel.superview == nil)
        {
            // add and center the "No Photos" label
            [self.tableView addSubview:self.noPhotosLabel];
            
            self.noPhotosLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            _labelConstraintForX = [NSLayoutConstraint constraintWithItem:self.noPhotosLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.tableView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0];
            _labelConstraintForY = [NSLayoutConstraint constraintWithItem:self.noPhotosLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.tableView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:100.0];
            [self.tableView addConstraints:@[self.labelConstraintForX, self.labelConstraintForY]];
        }
    }
    else
    {
        if (self.noPhotosLabel.superview != nil)
        {
            // remove the no photos label from the table
            [self.tableView removeConstraint:self.labelConstraintForX];
            [self.tableView removeConstraint:self.labelConstraintForY];
            [self.noPhotosLabel removeFromSuperview];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self hideOrShowNoRecordsLabel];

    return (self.searchController.isActive) ? self.filteredPhotos.count : self.photos.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CloudPhoto *record =
        (self.searchController.active) ? self.filteredPhotos[indexPath.row] : self.photos[indexPath.row];
    ((PhotoTableCell *)cell).photo = record;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoTableCell *cell = (PhotoTableCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    return cell;
}


#pragma mark - UISearchResultsUpdating

// Called when the search bar's text has changed
//
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (self.searchControllerActiveFromPreviousView)
    {
        // search controller was active at the time we navigated to the detail view controller
        // no need to start a re-filter again
        //
        _searchControllerActiveFromPreviousView = NO;
    }
    else
    {
        [self finishPhotoFilteringByTitle:self.searchController.searchBar.text photos:self.searchedPhotos];
    }
}


#pragma mark - DetailViewControllerDelegate

// we are being notified by APLDetailViewController, that a photo was added
- (void)detailViewController:(APLDetailTableViewController *)viewController didAddCloudPhoto:(CloudPhoto *)photo
{
    // add the photo to the table
    [self updateTableWithRecordID:photo.cloudRecord.recordID reason:CKQueryNotificationReasonRecordCreated];
}

// we are being notified by APLDetailViewController, that a photo was changed
- (void)detailViewController:(APLDetailTableViewController *)viewController didChangeCloudPhoto:(CloudPhoto *)photo
{
    // update the photo in the table
    [self updateTableWithRecordID:photo.cloudRecord.recordID reason:CKQueryNotificationReasonRecordUpdated];
}

// we are being notified by APLDetailViewController, that a photo was deleted
- (void)detailViewController:(APLDetailTableViewController *)viewController didDeleteCloudPhoto:(CloudPhoto *)photo
{
    // delete the photo in the table
    [self updateTableWithRecordID:photo.cloudRecord.recordID reason:CKQueryNotificationReasonRecordDeleted];
}


#pragma mark - Core Location

// we received a location update
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = locations[0];
    
    // now that we have the user's location, add the "Near Me" scope choice
    // to the search bar, if it doesn't already exist in the scope bar
    //
    NSMutableArray *scopeTitles = [self.searchController.searchBar.scopeButtonTitles mutableCopy];
    if (scopeTitles.count == 3)
    {
        [scopeTitles addObject:NSLocalizedString(@"Near Me Segment Item Title", nil)];
        self.searchController.searchBar.scopeButtonTitles = scopeTitles;
    }
    
    if (self.wasResumed)    // were we re-activated from the background?
    {
        if (self.searchController.searchBar.selectedScopeButtonIndex == kNearMeScope)
        {
            // if searching for "near me" as scope and in case the user moved his device since we were opened last,
            // update the table with the newer user location.
            //
            [self searchNearMe];
        }
        _wasResumed = NO;
    }
}

// listen for authorization status changes on allowing to discover the user's location
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
    {
        // user changed acccess to denied in System Preferences, remove tracking user location
        _currentLocation = nil;
    }
    else
    {
        // we can now start scanning for the user's location
        //
        // The following obtains a quick fix on the user’s location.
        // Doing so automatically stops location services once the request has been fulfilled,
        // letting location hardware power down if not being used elsewhere.
        // Location updates requested in this manner are delivered by a callback to the locationManager:didUpdateLocations: delegate method
        //
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
            authStatus == kCLAuthorizationStatusAuthorizedAlways)
        {
            [self.locationManager requestLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.currentLocation = nil;
}


#pragma mark - UIStateRestoration

/* we restore several items for state restoration:
 1) Search controller's active state,
 2) search text,
 3) first responder status
*/
static NSString *SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";
static NSString *SearchBarScopeKey = @"SearchScopeBarScopeKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = self.searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive)
    {
        [coder encodeBool:[self.searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:self.searchController.searchBar.text forKey:SearchBarTextKey];
    
    // encode the search bar scope button index
    [coder encodeInteger:self.searchController.searchBar.selectedScopeButtonIndex forKey:SearchBarScopeKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    _searchControllerText = [coder decodeObjectForKey:SearchBarTextKey];
    
    // restore the scope button index in the search field
    _searchControllerScopeIndex = [coder decodeIntegerForKey:SearchBarScopeKey];
}

@end

