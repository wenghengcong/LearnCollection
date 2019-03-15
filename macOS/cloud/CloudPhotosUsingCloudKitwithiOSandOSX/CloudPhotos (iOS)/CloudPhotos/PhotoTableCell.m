/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom UITableViewCell for displaying photo information in the main table view.
 */

#import "PhotoTableCell.h"
#import "APLCloudManager.h"
#import "AppDelegate.h"
#import "CloudPhoto.h"

@interface PhotoTableCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImage;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


#pragma mark -

@implementation PhotoTableCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.photo != nil)
    {
        self.nameLabel.text = [self.photo getPhotoTitle];
        
        // find the CKAsset (pointing to the actual photo)
        self.photoImage.image = [self.photo getPhotoImage];
        
        // we provide the owner of the current photo in the subtite of our cell,
        // this could take a while, so provide activity indicator
        //
        self.ownerLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        
        [self.photo photoOwner:^(NSString *owner) {
            
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            
            self.ownerLabel.hidden = NO;
            self.ownerLabel.text = owner;
        }];
    }
}

@end
