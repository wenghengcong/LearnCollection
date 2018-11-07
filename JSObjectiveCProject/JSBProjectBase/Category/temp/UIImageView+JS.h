//
//  UIImageView+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(JS)

#pragma mark- 初始化

+ (id)imageViewWithImageNamed:(NSString*)imageName;
+ (id)imageViewWithFrame:(CGRect)frame;
+ (id)imageViewWithStretchableImage:(NSString*)imageName Frame:(CGRect)frame;
- (void) setImageWithStretchableImage:(NSString*)imageName;
+ (id) imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration;

#pragma mark- 水印

// 画水印
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;
- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;

- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

#pragma mark- 设置

-(void)setRoundedView:(UIImageView *)roundedView;



@end
