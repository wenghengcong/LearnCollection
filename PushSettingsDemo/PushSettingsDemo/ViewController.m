//
//  ViewController.m
//  PushSettingsDemo
//
//  Created by WengHengcong on 4/20/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self debugPushSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)debugPushSettings {

    //获取系统版本号
    CGFloat sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    //判断“允许通知”开关是否打开
    BOOL pushAllowNotificationOn =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    NSString * pushAllowNotification = pushAllowNotificationOn ? @"on" : @"off";
    
    NSUInteger pushOption = 0;
    
    if (sysVersion >= 8.0)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        pushOption = types;
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        pushOption = types;
    }
    
    NSString *pushOptionSwitchOn = @"Alert/Sound/Badge All Off";
    if (pushAllowNotificationOn && (pushOption == 0)) {
        //“允许通知”打开，但是子开关全部是关闭的
        NSString *msg = @"Please Switch Alert/Sound/Badge On ";
        UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Service On,Receive Off" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setting", nil];
        alert_push.tag = 1;
        [alert_push show];
        
        NSLog(@" Push Notification ON");
    }else if(pushAllowNotificationOn && (pushOption != 0)){
        //“允许通知”打开，子开关有打开的
        switch (pushOption) {
            case 1:
                pushOptionSwitchOn = @"Alert:Off | Sound:Off | Badge:On";
                break;
            case 2:
                pushOptionSwitchOn = @"Alert:Off | Sound:On | Badge:Off";
                break;
            case 3:
                pushOptionSwitchOn = @"Alert:Off | Sound:On | Badge:On";
                break;
            case 4:
                pushOptionSwitchOn = @"Alert:On | Sound:Off | Badge:Off";
                break;
            case 5:
                pushOptionSwitchOn = @"Alert:On | Sound:Off | Badge:On";
                break;
            case 6:
                pushOptionSwitchOn = @"Alert:On | Sound:On | Badge:Off";
                break;
            case 7:
                pushOptionSwitchOn = @"Alert:On | Sound:On | Badge:On";
                break;
            default:
                break;
        }
        
        UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Service On,Receive On" message:pushOptionSwitchOn delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setting", nil];
        alert_push.tag = 1;
        [alert_push show];
        [alert_push dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@" Push Notification ON");
    }else{
        //“允许通知”关闭
        NSString *msg = @"Please press ON to enable Push Notification";
        UIAlertView *alert_push = [[UIAlertView alloc] initWithTitle:@"Service Off" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setting", nil];
        alert_push.tag = 2;
        [alert_push show];
        NSLog(@" Push Notification OFF");

    }
    
    NSLog(@"Push AllowNotification: %@ ",pushAllowNotification);
    NSLog(@"Push Settings: %@ -- %lu",pushAllowNotification ,(unsigned long)pushOption);
    NSLog(@"Push Switch: %@ ",pushOptionSwitchOn);

}

@end
