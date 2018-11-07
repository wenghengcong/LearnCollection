//
//  UIFont+JSBProject.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/5.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger    TinyFontSize = 10;
static NSInteger    SmallFontSize = 12;
static NSInteger    MiddleFontSize = 13;
static NSInteger    LargeFontSize = 15;
static NSInteger    HugeFontSize = 17;

static NSString *FontName1 = @"";
static NSString *FontName2 = @"";
static NSString *FontName3 = @"";

@interface UIFont (JSBProject)

#pragma mark - 系统字体

+ (UIFont *)tinySizeSystemFont;

+ (UIFont *)smallSizeSystemFont;

+ (UIFont *)middleSizeSystemFont;

+ (UIFont *)largeSizeSystemFont;

+ (UIFont *)hugeSizeSystemFont;

//加粗
+ (UIFont *)tinySizeBoldSystemFont;

+ (UIFont *)smallSizeBoldSystemFont;

+ (UIFont *)middleSizeBoldSystemFont;

+ (UIFont *)largeSizeBoldSystemFont;

+ (UIFont *)hugeSizeBoldSystemFont;

#pragma mark - 自定义字体

+ (UIFont *)tinySizeFontName1Font;

+ (UIFont *)smallSizeFontName1Font;

+ (UIFont *)middleSizeFontName1Font;

+ (UIFont *)largeSizeFontName1Font;

+ (UIFont *)hugeSizeFontName1Font;

//加粗
+ (UIFont *)tinySizeBoldFontName1Font;

+ (UIFont *)smallSizeBoldFontName1Font;

+ (UIFont *)middleSizeBoldFontName1Font;

+ (UIFont *)largeSizeBoldFontName1Font;

+ (UIFont *)hugeSizeBoldFontName1Font;


@end
