# CloudKit Share: Using CloudKit share APIs

## Description

This sample demonstrates how to use CloudKit share APIs to share private data across different iCloud accounts. It also shows how to use CloudKit subscriptions to maintain a local cache of CloudKit data.


### Schema

This sample requires two record types, Topic and Notes. You can create them by opening CloudKit Dashboard in Safari (https://icloud.developer.apple.com/dashboard/), picking the iCloud container you are going to use, and adding the following record types and fields: 

Topic
    name:   String
Note
    title:  String
    topic:  Reference

Be sure to check the "Sort", "Query", and "Search" box.

Note that CloudKit errors will be triggered if the schema doesn't exist in your iCloud container, so make sure to set up your schema before running the sample. After creating the schema, you might need to wait a few minutes for CloudKit servers to finish the synchronization. 

## Setup

1. Open the project file of this sample (`CloudShares.xcodeproj`) with the latest version of Xcode.

2. In the General pane of the target settings, change the bundle identifier under Identity section. The bundle identifier is used to create the app’s default container.  Also, pick your team under the Signing section. If you haven't log in with your developer account yet, go to Xcode preferences -> Accounts to do that.

3. In the Capabilities pane, make sure that iCloud is on and the CloudKit option is checked. The project is set to use the default container. If you specify a custom container here, you need to change the line of code in `AppDelegate.swift` to create the `CKContainer` object with your custom container identifier.

4. Make sure your testing devices run the latest iOS and are signed in with iCloud accounts. This sample doesn't work on iOS Simulators because iOS Simulators don't support notifications. 

5. Before being able to play with the "Share" button, you need to create a custom zone in the private database, and put some records in it. Only custom zone records can be shared. 

## How to use this sample 

You can follow these steps to see how CloudKit Share works:

1. Prepare three devices, say device A, B, and C, log in device A and B with a same iCloud account, and C with the other. Then install this sample on all the deivces and run it. If the system asks you to allow notifications for your app, go ahead to allow it.

2. On device A, tap the menu button on the main view's top-left corner to show the zone view, then tap the Edit button to add a zone in your private database. If the devices are configured correctly, the zone will be synced to device B after a while.

3. Tap the zone to switch to the main view, then use the Edit button to add a topic which should again be synced to device B. Every topic has a Share button on the right.

4. Tap the Share button to show the `UICloudSharingController` view, follow the UI to send out an invitation to the other iCloud account that is used on device C. You can use whatever way provided in `UICloudSharingController` to send the invitation. 

5. When you get the invitation on device C, tap the link to accept the invitation and open the share. The system should then launch this sample and the accepted share will show on the main view.

6. From here, you can play more with the sample: On device A, you can use the Share button again to stop sharing a topic or change the permission of a participant; on device C, you can remove your participation from the shared topic or add a note under it if you have the permission. The changes you make should be synced across all the devices.

## Requirements

### Build

Latest iOS (iOS 11.3 or later) SDK ; Xcode 9 or later

### Runtime

iOS 10.2 or later

Copyright (C) 2017-2018 Apple Inc. All rights reserved.
