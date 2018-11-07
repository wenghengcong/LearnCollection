//
//  UIAlertView+JS.h
//  timeboy
//
//  Created by whc on 15/5/25.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);


@interface UIAlertView(JS)

+ (UIAlertView *)alertViewWithTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title Message:(NSString *)message;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title;


+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
