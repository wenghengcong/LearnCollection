/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Object to describe a photo in this app: a wrapper for CKRecord
 */

@import UIKit;
@import CloudKit;

@interface CloudPhoto : NSObject

@property (nonatomic, strong) CKRecord *cloudRecord;

@property (nonatomic, strong, getter = getPhotoTitle, setter = setPhotoTitle:) NSString *photoTitle;
@property (nonatomic, strong, getter = getPhotoDate, setter = setPhotoDate:) NSDate *photoDate;
@property (nonatomic, strong, getter = getPhotoLocation, setter = setPhotoLocation:) CLLocation *photoLocation;

@property (assign) BOOL isMyPhoto;
@property (assign) double distanceFromUser;   // in kilometers

- (id)initWithRecord:(CKRecord *)record;

- (BOOL)isPhotoNearMe;
- (BOOL)isRecentPhoto;

- (UIImage *)getPhotoImage;
- (void)setPhotoImage:(NSURL *)imageURL;

- (void)photoOwner:(void (^)(NSString *owner))completionHandler;

@end
