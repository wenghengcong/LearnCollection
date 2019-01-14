//
//  UIColor+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(JS)

#pragma mark- 十六进制颜色
/**
 *  十六进制颜色
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;


+ (UIColor *)colorWithHexColorInteger:(UInt32)hexColorInteger;
+ (UIColor *)colorWithHexColorInteger:(UInt32)hexColorInteger alpha:(CGFloat)alpha;


- (NSString *)HEXString;

#pragma mark- RGB
/**
 *  从RGBA字符串转换为UIColor
 *  @param rgba (1,1,1,1)
 */
+ (UIColor *)colorWithRGBAString:(NSString *)rgbaStr;

/**
 *  从RGB返回颜色，只要给出0-255数值即可
 */
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

#pragma mark- Random
+ (UIColor *)randomColor;

#pragma mark- gradient
/**
 *  渐变
 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
#pragma mark- web

/**
 *  获取canvas用的颜色字符串
 */
- (NSString *)canvasColorString;

/**
 *  获取网页颜色字串
 */
- (NSString *)webColorString;

#pragma mark- modify

- (UIColor *)invertedColor;
- (UIColor *)colorForTranslucency;
- (UIColor *)lightenColor:(CGFloat)lighten;
- (UIColor *)darkenColor:(CGFloat)darken;

#pragma is same color

-(BOOL)matchesColor:(UIColor *)color error:(NSError *)error;

@end
