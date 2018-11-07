//
//  NotificationViewController.h
//  NotificationContent
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

//Content Extension 用来修改通知弹出的界面，并且通过category来进行加以定制。
/*假如带小图文的通知，通知界面未经过这里修改，则会展示成带图片的通知
未经过Content Extension：
  1.通知不带图片，直接显示title/body的通知；
  2.通知带图片，显示为title/图片/body的通知；
 
经过Content Extension，直接加载定制的通知界面。
*/


@interface NotificationViewController : UIViewController <UNNotificationContentExtension>


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *showImageV;

@property (weak, nonatomic) IBOutlet UIImageView *blurtImageV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 图片高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

/**
 内容与图片的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;

/**
 蒙版高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blurImageH;

/**
 内容高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end

