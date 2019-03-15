/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The detail view controller showing a specific photo.
 */

@import UIKit;
@import CloudKit;

@class CloudPhoto;

@protocol DetailViewControllerDelegate;

@interface APLDetailTableViewController : UITableViewController

@property (nonatomic, weak, readwrite) id<DetailViewControllerDelegate> delegate;

@property (nonatomic, strong) CloudPhoto *photo;

// called when we receive notification from our App Delegate that the user logged in our out
- (void)loginUpdate;

@end


#pragma mark -

// protocol used to inform our parent table view controller to update its table if the given photo was added, changed or deleted
@protocol DetailViewControllerDelegate <NSObject>

@required

- (void)detailViewController:(APLDetailTableViewController *)viewController didChangeCloudPhoto:(CloudPhoto *)photo;
- (void)detailViewController:(APLDetailTableViewController *)viewController didAddCloudPhoto:(CloudPhoto *)photo;
- (void)detailViewController:(APLDetailTableViewController *)viewController didDeleteCloudPhoto:(CloudPhoto *)photo;

@end
