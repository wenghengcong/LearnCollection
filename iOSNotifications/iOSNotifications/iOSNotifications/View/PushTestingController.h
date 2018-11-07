//
//  PushTestingController.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/14.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JSPushService.h"

@interface PushTestingController : UIViewController<UIAlertViewDelegate>

+ (NSSet *)categoriesAction4Test;
+ (void)setupWithOption:(NSDictionary *)launchOptions;
@end
