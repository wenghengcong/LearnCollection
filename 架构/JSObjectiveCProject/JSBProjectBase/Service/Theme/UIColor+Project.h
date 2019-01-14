//
//  UIColor+JSBProject.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/5.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Project)

#pragma mark - bar

+ (UIColor *)navigationBarTitleTextColor;

+ (UIColor *)navigationBarBackgroundColor;

+ (UIColor *)tabBarTitleTextColor;

+ (UIColor *)tabBarBackgroundColor;

#pragma mark - text

+ (UIColor *)labelSubtitleTextColor;

+ (UIColor *)labelTitleTextColor;

+ (UIColor *)textFieldTextColor;

+ (UIColor *)textFieldPlaceholderTextColor;

+ (UIColor *)textViewTextColor;

+ (UIColor *)textViewPlaceholderTextColor;

#pragma mark - button

+ (UIColor *)buttonTitleTextColor;

+ (UIColor *)buttonNormalBackgroundColor;

+ (UIColor *)buttonHighlightBackgroundColor;

+ (UIColor *)buttonSelectedBackgroundColor;

#pragma mark - other

+ (UIColor *)viewBackgroundColor;

+ (UIColor *)badgeBackgroundColor;


@end
