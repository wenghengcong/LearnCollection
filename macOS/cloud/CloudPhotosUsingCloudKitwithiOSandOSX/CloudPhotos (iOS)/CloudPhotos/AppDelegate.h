/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This sample's application delegate for push notiications (CKSubscriptions) from CloudKit.
 */

@import UIKit;

#warning Make sure to set your real iCloud container ID
#define FINAL_CONTAINER_ID "your_real_container_id"

#define CloudManager [APLCloudManager sharedInstance:@FINAL_CONTAINER_ID]

@interface AppDelegate : NSObject <UIApplicationDelegate>

@end
