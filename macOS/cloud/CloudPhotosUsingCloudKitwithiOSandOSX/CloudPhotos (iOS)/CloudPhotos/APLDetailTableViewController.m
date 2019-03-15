/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The detail view controller showing a specific photo.
 */

#import "APLDetailTableViewController.h"
#import "APLMapViewController.h"
#import "APLPhotoViewController.h"

#import "APLCloudManager.h"
#import "AppDelegate.h"

#import "CloudPhoto.h"

@import MapKit;
@import Photos;

// segue constants
static NSString * const kShowMapSegueID = @"showMap";
static NSString * const kShowPhotoSegueID = @"showPhoto";

@interface APLDetailTableViewController () <UITextFieldDelegate,
                                            // needed for UIImagePickerViewController:
                                            UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextField *titleField;

@property (nonatomic, weak) IBOutlet UILabel *createdByLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *createdByActivityIndicator;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

// keep track of these so we don't have to fetch them later from the asset library
@property (nonatomic, strong) CLLocation *photoLocation;    // photo asset geo-tagged location
@property (nonatomic, strong) NSDate *photoDate;            // photo asset creation date

@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (assign) BOOL editCancelled;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (assign) BOOL photoPickerDismissed;

@property (nonatomic, strong) CLGeocoder *geocoder; // for location

@property (nonatomic, assign) BOOL restoringFromState;    // flag indicating we are performing UIStateRestoration (CKRecord queries are asynchronous)

@end


#pragma mark -

@implementation APLDetailTableViewController


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // we want the table edit button to the right of the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.enabled = NO;
    
    // used later when editing
    _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                  target:self
                                                                  action:@selector(cancelAction:)];
    
    // access to change the photo can be done in two places:
    //     1) bottom toolbar, 2) tap the actual image while in edit mode
    //
    // setup the toolbar
    UIBarButtonItem *cameraButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                      target:self
                                                      action:@selector(cameraAction:)];
    // before setting the camera button to the toolbar, first check if we have photo library access
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
                // user has denied access to photo library
                cameraButton.enabled = NO;  // can't choose any photos
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self setToolbarItems:@[cameraButton] animated:YES];
        });
    }];
    
    // setup the single tap on the image
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(imageTapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    
    // listen for text field changes, so we can update our Done button
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:self.titleField
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
        // note: we change the edit button enable state in the nav bar only for the first text field has text content
        //
        // enable the Done button only if we have a title and image
        //
        self.editButtonItem.enabled = [self doneButtonAllowed];
    }];
    
    // listen for updates due to push notification processing, so we can update our UI
    [[NSNotificationCenter defaultCenter] addObserverForName:[APLCloudManager UpdateContentWithNotification]
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {

                                                      CKQueryNotification *queryNotification = notification.object;
                                                      [self handleContentWithNotification:queryNotification];
                                                  }];
}

- (void)setupInitialUI
{
    // we might be called as a result of the photo picker dismissal
    if (!self.photoPickerDismissed)
    {
        [self updateNavigationBar]; // this will update our UI to reflect user login
        
        // initial view appeared
        if (self.photo != nil)
        {
            [self setupTableElements];
        }
        else
        {
            // we are opening for creation since there is no photo handed to us
            self.title = NSLocalizedString(@"Add Title", nil);
            
            [self setEditing:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // if we are restoring our state, delay the initial UI setup until we have an actual photo to restore
    if (!self.restoringFromState)
    {
        [self setupInitialUI];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.titleField];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[APLCloudManager UpdateContentWithNotification]
                                                  object:nil];
}


#pragma mark - User Interface

- (void)setupTableElements
{
    // set the photo to our image view
    self.imageView.image = [self.photo getPhotoImage];

    // title:
    self.title = self.photo.photoTitle;
    self.titleField.text = self.photo.photoTitle;
    
    // owner:
    // we provide the owner of the current photo in the subtite of our cell
    // (this will be filled out asynchronously) so start progress indicator
    // in its place in case obtaining the owner name takes some time
    //
    self.createdByLabel.text = @"";
    self.createdByActivityIndicator.hidden = NO;
    [self.createdByActivityIndicator startAnimating];
    
    [self.photo photoOwner:^(NSString *owner) {
        
        [self.createdByActivityIndicator stopAnimating];
        
        self.createdByLabel.text = owner;
    }];
    
    // date:
    // set the date field to match this photo
    NSDate *date = self.photo.photoDate;
    [self updateDateFieldFromDate:date];
    
    // location:
    // setup the map's location and label
    self.photoLocation = self.photo.photoLocation;
    [self updateLocationNameFromLocation:self.photoLocation];
}

// update our navigation bar so that the edit and add button states are correct according to user login
//
- (void)updateNavigationBar
{
    if ([CloudManager accountAvailable] && [CloudManager userLoginIsValid])
    {
        // we are logged in, iCloud drive is on, allow for edits
        // but we still need to check if it's our photo (we can edit only our photos)
        //
        self.editButtonItem.enabled = [CloudManager isMyRecord:self.photo.cloudRecord.creatorUserRecordID];
    }
    else
    {
        // we are not logged in, don't allow for changes
        self.editButtonItem.enabled = NO;
    }
}

// in order to finish editing (allow the Done button to be enabled) and to save this photo,
// we must have a title, image and the photo belongs to us
//
- (BOOL)doneButtonAllowed
{
    return (self.titleField.text.length > 0 && self.imageView.image != nil && [self editingAllowed]);
}

- (BOOL)editingAllowed
{
    if (self.photo != nil)
    {
        return self.photo.isMyPhoto;
    }
    else
    {
        return YES; // no photo means we are adding a new one, we own it, editing allowed
    }
}


#pragma mark - Actions

- (void)cancelAction:(id)sender
{
    _editCancelled = YES;
    
    [self setEditing:NO animated:YES];
    
    _editCancelled = NO;
    
    if (self.photo == nil)
    {
        // no photo defined yet, go back, user cancelled
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self setupTableElements];    // reset our cells back to initial state
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // hide/show toolbar on edit toggle
    [self.navigationController setToolbarHidden:!editing animated:YES];
    
    if (editing)
    {
        // entering edit mode
        self.navigationItem.leftBarButtonItem = self.cancelButton;
    }
    else
    {
        // leaving edit mode: Done button pressed or Cancel button is pressed
        
        // dismiss keyboard if our title field is first responder
        if ([self.titleField isFirstResponder])
        {
            [self.titleField resignFirstResponder];
        }
        
        // save the photo
        if (!self.editCancelled)    // don't continue here if user cancelled
        {
            if (self.photo != nil)
            {
                // we have an existing photo to save out the edit
                //
                [self.photo setPhotoTitle:self.titleField.text];
                
                // this will create a sized down/compressed cached image in the caches folder
                NSURL *imageURL = [CloudManager createCachedImageFromImage:self.imageView.image];
                if (imageURL != nil)
                {
                    [self.photo setPhotoImage:imageURL];
                    [self.photo setPhotoDate:self.photoDate];
                    [self.photo setPhotoLocation:self.photoLocation];
                }
                
                [CloudManager modifyRecord:self.photo.cloudRecord completionHandler:^(CKRecord *record, NSError *error) {
                    if (error != nil)
                    {
                        NSLog(@"Error modifying existing photo in %@: error[%ld] %@",
                              NSStringFromSelector(_cmd), (long)error.code, error.localizedDescription);
                    }
                    else
                    {
                        // assign our newly returned photo
                        _photo = [[CloudPhoto alloc] initWithRecord:record];
                        
                        //NSLog(@"\nSave record succeeded: recordID = %@", record.recordID);
                        
                        [self setupTableElements];  // update our table cells
                        
                        // inform our delegate to re-fetch since we changed an existing photo
                        [self.delegate detailViewController:self didChangeCloudPhoto:self.photo];
                    }
                }];
            }
            else
            {
                // we don't have a photo yet, (user tapped + button in the main table), so add it and save
                //
                __weak __typeof(self) weakSelf = self;
                [CloudManager addRecordWithImage:self.imageView.image
                                           title:self.titleField.text
                                            date:self.photoDate
                                        location:self.photoLocation
                               completionHandler:^(CKRecord *record, NSError *error) {
                                   if (record != nil && error == nil)
                                   {
                                       weakSelf.photo = [[CloudPhoto alloc] initWithRecord:record];
                                       [weakSelf setupTableElements];  // update our table cells
                                       
                                       // inform our delegate to refetch since added a new photo
                                       [weakSelf.delegate detailViewController:weakSelf didAddCloudPhoto:weakSelf.photo];
                                   }
                               }];
            }
        }
        
        // remove the cancel button
        self.navigationItem.leftBarButtonItem = nil;
    }
}


#pragma mark - Segue support

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldPerform = NO;
    if ([identifier isEqualToString:kShowMapSegueID])
    {
        shouldPerform = [self isValidLocation:self.photoLocation];
    }
    return shouldPerform;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowMapSegueID])
    {
        // navigate to APLMapViewController: the detail screen of the map
        APLMapViewController *mapViewController = (APLMapViewController *)segue.destinationViewController;
        mapViewController.location = self.photoLocation;
    }
    else if ([segue.identifier isEqualToString:kShowPhotoSegueID])
    {
        // navigate to APLPhotoViewController: the detail photo screen
        APLPhotoViewController *photoViewController = (APLPhotoViewController *)segue.destinationViewController;
        photoViewController.photo = self.imageView.image;
    }
}


#pragma mark - UIImagePickerController

- (void)pickImage
{
    if ([self editingAllowed])  // only allow editing our photos
    {
        if (!self.isEditing)    // user can tap the photo for editing while not in edit mode, so we must enter edit mode
        {
            [self setEditing:YES animated:NO];
        }
        
        if (self.imagePicker == nil)
        {
            _imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.delegate = self;
            self.imagePicker.allowsEditing = YES;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion:^ {
            
            // do something here after the image picker is done presenting...
        }];
    }
}

- (void)cameraAction:(id)sender
{
    [self pickImage];
}

- (void)imageTapDetected:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isEditing)
    {
        // open the image picker to pick a new photo
        [self pickImage];
    }
    else
    {
        // call our segue to display the photo
        [self performSegueWithIdentifier:kShowPhotoSegueID sender:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (image != nil)
    {
        self.imageView.image = image;
        
        // we want access to the meta data of that photo (mod date and location)
        //
        PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[info[UIImagePickerControllerReferenceURL]] options:nil] lastObject];
        
        // obtain the creation date property from the asset
        _photoDate = asset.creationDate;
        [self updateDateFieldFromDate:self.photoDate];
        
        // obtain the location property from the asset
        _photoLocation = asset.location;
        
        // then change location label
        [self updateLocationNameFromLocation:self.photoLocation];
        
        self.navigationItem.rightBarButtonItem.enabled = [self doneButtonAllowed];
    }
    
    _photoPickerDismissed = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        _photoPickerDismissed = NO;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _photoPickerDismissed = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        _photoPickerDismissed = NO;
    }];
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;  // no deletion or reordering in this view controller
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self editingAllowed];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // the user can tap the name field while not in edit mode, which will allow the edit session to start
    if (!self.isEditing)
    {
        [self setEditing:YES animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - NSDate

- (void)updateDateFieldFromDate:(NSDate *)date
{
    if (date != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        self.dateLabel.text = [dateFormatter stringFromDate:date];
    }
}


#pragma mark - CLLocation

- (BOOL)isValidLocation:(CLLocation *)location
{
    return (location != nil && location.coordinate.latitude != 0 && location.coordinate.longitude != 0);
}

- (void)updateLocationNameFromLocation:(CLLocation *)location
{
    UITableViewCell *locationCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if ([self isValidLocation:location])
    {
        if (self.geocoder == nil)
        {
            _geocoder = [[CLGeocoder alloc] init];
        }
        
        // get nearby address
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks != nil && placemarks.count > 0)
            {
                CLPlacemark *placemark = placemarks[0];
                if (placemark.locality != nil && placemark.administrativeArea != nil)
                {
                    if (placemark.thoroughfare != nil)
                    {
                        self.locationLabel.text =
                            [NSString stringWithFormat:@"%@: %@, %@", placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
                    }
                    else
                    {
                        self.locationLabel.text =
                            [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
                    }
                }
            }
        }];
        
        // since we have a location, we can navigate to a detail map
        locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.locationLabel.text = NSLocalizedString(@"Location Unavailable", nil);
        
        // no location, so we block navigating to a detail map
        locationCell.accessoryType = UITableViewCellAccessoryNone;
    }
}


#pragma mark - Account Change Notification

- (void)loginUpdate
{
    // the user has signed in or out of iCloud, so we need to refresh our UI reflect user login
    //
    [self updateNavigationBar];
}


#pragma mark - Push Notifications

- (void)handleContentWithNotification:(CKQueryNotification *)notification
{
    // don't bother the user with an alert while editing this photo
    if (!self.isEditing)
    {
        // we are not editing our current photo, so process this notification
        //
        // a photo has come in that was added, deleted or updated,
        // update this view controller's photo
        //
        CKQueryNotificationReason reason = notification.queryNotificationReason;
        CKRecordID *recordID = notification.recordID;
        
        if ([recordID isEqual:self.photo.cloudRecord.recordID])
        {
            // here we can examine the title of the photo record without a query
            //
            NSString *baseMessage;
            NSString *reasonMessage;
            switch (reason)
            {
                case CKQueryNotificationReasonRecordUpdated:
                    baseMessage = NSLocalizedString(@"Photo Generic Changed Notif Message", nil);
                    break;
                    
                case CKQueryNotificationReasonRecordDeleted:
                    baseMessage = NSLocalizedString(@"Photo Generic Removed Notif Message", nil);
                    break;
                    
                default:
                    break;
            }
            if (baseMessage != nil)
            {
                // we are only interested in the kPhotoTitle attribute
                //  (because we set the CKSubscription's CKNotificationInfo 'desiredKeys' when we subscribed earlier)
                NSDictionary *recordFields = [notification recordFields];
                NSString *photoTitle = recordFields[[APLCloudManager PhotoTitleAttribute]];
                
                reasonMessage = [NSString stringWithFormat:baseMessage, photoTitle];
            }

            if (reason == CKQueryNotificationReasonRecordDeleted)
            {
                // alert user that our current photo was deleted, and then we leave this view controller
                //
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:reasonMessage
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK Button Title", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     // dissmissal of alert completed, update the table (remove the photo)
                                                                     [self.delegate detailViewController:self didDeleteCloudPhoto:self.photo];
                                                                     
                                                                     // pop this view controller back to our root table
                                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                                 }];
                
                [alert addAction:OKAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (reason == CKQueryNotificationReasonRecordUpdated)
            {
                // our photo was changed, alert user
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:reasonMessage
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK Button Title", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     // for updates of our photo: 'recordID' was modified, so search only for our updated photo
                                                                     //
                                                                     [CloudManager fetchRecordWithID:recordID completionHandler:^(CKRecord *foundRecord, NSError *error) {
                                                                         
                                                                         if (error != nil)
                                                                         {
                                                                             // error fetching the photo that was changed or added
                                                                             NSLog(@"An error occured in '%@': error[%ld] %@",
                                                                                   NSStringFromSelector(_cmd), (long)error.code, error.localizedDescription);
                                                                         }
                                                                         else
                                                                         {
                                                                             if (foundRecord != nil)
                                                                             {
                                                                                 _photo = [[CloudPhoto alloc] initWithRecord:foundRecord];
                                                                                 [self setupTableElements];
                                                                             }
                                                                         }
                                                                     }];
                                                                 }];
                
                [alert addAction:OKAction];
                [self presentViewController:alert animated:YES completion:nil];  
            }
        }
    }
}


#pragma mark - UIStateRestoration

static NSString * const DetailViewControllerRecordKey = @"DetailViewControllerRecordID";

// please note that this can be called when we receive any push notifications in the background
//
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    // encode just the recordID for state restoration
    [coder encodeObject:self.photo.cloudRecord.recordID forKey:DetailViewControllerRecordKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the product
    CKRecordID *recordID = [coder decodeObjectForKey:DetailViewControllerRecordKey];
    if (recordID != nil)
    {
        // flag ourselves that we are performing UIStateRestoration
        // (a CKRecord query is asynchronous and viewWillAppear will be called before we are ready)
        //
        _restoringFromState = YES;
        
        // find our CKRecord we had in this view controller from last time
        [CloudManager fetchRecordWithID:recordID completionHandler:^(CKRecord *foundRecord, NSError *error) {
            
            if (error != nil)
            {
                // error fetching the photo that was changed or added
                NSLog(@"An error occured while restoring view controller: error[%ld] %@", (long)error.code, error.localizedDescription);
            }

            if (foundRecord != nil)
            {
                // we found the restord to restore in this view controller
                _photo = [[CloudPhoto alloc] initWithRecord:foundRecord];
                _restoringFromState = NO;
                [self setupInitialUI];
            }
            else
            {
                // oops, the photo we expected from last time no longer exists, so exit this detail view
                [self.navigationController popViewControllerAnimated:NO];
            }
        }];
    }
    else
    {
        // oops, the photo we expected from last time no longer exists
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end

