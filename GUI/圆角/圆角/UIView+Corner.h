//
//  UIView+Corner.h
//  圆角
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)

- (void)ho_clipCorners:(UIRectCorner)corners
                radius:(CGFloat)radius;


- (void)ho_clipCorners:(UIRectCorner)corners
                radius:(CGFloat)radius
                border:(CGFloat)width
                 color:(nullable UIColor *)color;

- (UIImage *)ho_drawRectWithRoundedCorner:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                              borderColor:(UIColor *)borderColor
                          backGroundColor:(UIColor*)bgColor;

@end

NS_ASSUME_NONNULL_END
