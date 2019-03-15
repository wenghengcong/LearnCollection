/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's primary table view controller showing the list of photos.
 */

#import "APLDetailTableViewController.h" // for DetailViewControllerDelegate

@interface APLMainTableViewController : UITableViewController <DetailViewControllerDelegate>

// called by our AppDelegate when the user has logged in our out
- (void)loginUpdate;

@end
