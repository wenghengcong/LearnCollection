//
//  UIButton+JS.h
//  timeboy
//
//  Created by whc on 15/5/12.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(JS)

#pragma mark- 创建按钮

/**
 *  创建一个普通的圆角按钮
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize BackgroundColor:(UIColor *)bgcolor Frame:(CGRect)rect Radius:(BOOL)isRadius;
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize BackgroundColor:(UIColor *)bgcolor Radius:(BOOL)isRadius;

/**
 *  创建一个带颜色的圆角按钮，圆角颜色同一般和titleColor一致，按钮背景色默认白色
 */
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize Frame:(CGRect)rect;
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize;
/**
 *  创建一个带颜色的圆角按钮，圆角颜色同一般和titleColor一致，可自定义背景色
 */
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize Frame:(CGRect)rect;
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize;

/**
 *  创建一个不带圆角和边框的有颜色的按钮，按钮背景为白色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize Frame:(CGRect)rect;
/**
 *  创建一个不带圆角和边框的有颜色的按钮，按钮背景为白色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize;
/**
 *  创建一个不带圆角和边框的有颜色的按钮，可设按钮背景色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize Frame:(CGRect)rect;
/**
 *  创建一个不带圆角和边框的有颜色的按钮，可设按钮背景色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor  BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize;

#pragma mark- 按钮设置
/**
 *  设置圆形按钮
 */
- (void)setRadius:(CGFloat)radius Color:(UIColor *)color;

/**
 *  反转按钮的文本与图片的位置
 */
- (void)reverseTitleAndImagePosition;

#pragma makr- indicator

/**
 Simple category that lets you replace the text of a button with an activity indicator.
 */

/**
 This method will show the activity indicator in place of the button text.
 */
- (void) showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void) hideIndicator;


#pragma mark- countdown
-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;

#pragma mark- block


#pragma mark- backgroundcolor
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

#pragma mark- submiting


/**
 *  @author foxsofter, 15-04-02 15:04:59
 *
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)beginSubmitting:(NSString *)title;

/**
 *  @author foxsofter, 15-04-02 15:04:13
 *
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)endSubmitting;

/**
 *  @author foxsofter, 15-04-02 15:04:17
 *
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;

@end
