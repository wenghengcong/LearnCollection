//
//  UILabel+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/5/28.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for UILabel-AutomaticWriting.
FOUNDATION_EXPORT double UILabelAutomaticWritingVersionNumber;

//! Project version string for UILabel-AutomaticWriting.
FOUNDATION_EXPORT const unsigned char UILabelAutomaticWritingVersionString[];

extern NSTimeInterval const UILabelAWDefaultDuration;

extern unichar const UILabelAWDefaultCharacter;

typedef NS_ENUM(NSInteger, UILabelAWBlinkingMode)
{
    UILabelAWBlinkingModeNone,
    UILabelAWBlinkingModeUntilFinish,
    UILabelAWBlinkingModeUntilFinishKeeping,
    UILabelAWBlinkingModeWhenFinish,
    UILabelAWBlinkingModeWhenFinishShowing,
    UILabelAWBlinkingModeAlways
};


@interface UILabel(JS)

#pragma mark- 创建一个label
/**
 *  创建一个自定义的label
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor HightTextColor:(UIColor *)hightColor Font:(UIFont *)font TextAlignment:(NSTextAlignment)align Frame:(CGRect)frame;
/**
 *  创建一个自定义的label
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor HightTextColor:(UIColor *)hightColor Font:(UIFont *)font TextAlignment:(NSTextAlignment)align ;

/**
 *  创建一个常用的lable：高亮白色 默认字体 左对齐 文本黑色
 */
- (UILabel*)initWithTitle:(NSString *)title FontSize:(CGFloat)fontsize;
/**
 *  创建一个常用的lable：高亮白色 默认字体 左对齐 文本黑色
 */
- (UILabel*)initWithTitle:(NSString *)title FontSize:(CGFloat)fontsize Frame:(CGRect)frame;


/**
 *  创建一个有文本颜色的label：高亮白色 默认字体 左对齐
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor FontSize:(CGFloat)fontsize;
/**
 *  创建一个有文本颜色的label：高亮白色 默认字体 左对齐
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor FontSize:(CGFloat)fontsize Frame:(CGRect)frame;

/**
 *  创建一个有文本颜色且可设置对齐方式的label：高亮白色 默认字体
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor TextAlignment:(NSTextAlignment)align FontSize:(CGFloat)fontsize;
/**
 *  创建一个有文本颜色且可设置对齐方式的label：高亮白色 默认字体
 */
- (UILabel*)initWithTitle:(NSString *)title TextColor:(UIColor*)textColor TextAlignment:(NSTextAlignment)align FontSize:(CGFloat)fontsize Frame:(CGRect)frame;


#pragma mark- adjustlabtel


// General method. If minSize is set to CGSizeZero then
// it is ignored
// =====================================================
- (void)adjustLabelToMaximumSize:(CGSize)maxSize
                     minimumSize:(CGSize)minSize
                 minimumFontSize:(int)minFontSize;

// Adjust label using only the maximum size and the
// font size as constraints
// =====================================================
- (void)adjustLabelToMaximumSize:(CGSize)maxSize
                 minimumFontSize:(int)minFontSize;

// Adjust the size of the label using only the font
// size as a constraint (the maximum size will be
// calculated automatically based on the screen size)
// =====================================================
- (void)adjustLabelSizeWithMinimumFontSize:(int)minFontSize;

// Adjust label without any constraints (the maximum
// size will be calculated automatically based on the
// screen size)
// =====================================================
- (void)adjustLabel;

#pragma mark- suggest size

- (CGSize)suggestedSizeForWidth:(CGFloat)width;
- (CGSize)suggestSizeForAttributedString:(NSAttributedString *)string width:(CGFloat)width;
- (CGSize)suggestSizeForString:(NSString *)string width:(CGFloat)width;

#pragma mark- auto size

/**
 * 垂直方向固定获取动态宽度的UILabel的方法
 *
 * @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)resizeLabelHorizontal;

/**
 *  水平方向固定获取动态宽度的UILabel的方法
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)resizeLabelVertical;

/**
 *  垂直方向固定获取动态宽度的UILabel的方法
 *
 *  @param minimumWidth minimum width
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)resizeLabelHorizontal:(CGFloat)minimumWidth;

/**
 *  水平方向固定获取动态宽度的UILabel的方法
 *
 *  @param minimumHeigh minimum height
 *
 *  @return 原始UILabel修改过的Rect的UILabel(起始位置相同)
 */
- (UILabel *)resizeLabelVertical:(CGFloat)minimumHeigh;

#pragma mark- automatic writing

@property (strong, nonatomic) NSOperationQueue *automaticWritingOperationQueue;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (void)setTextWithAutomaticWritingAnimation:(NSString *)text;

- (void)setText:(NSString *)text automaticWritingAnimationWithBlinkingMode:(UILabelAWBlinkingMode)blinkingMode;

- (void)setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration;

- (void)setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelAWBlinkingMode)blinkingMode;

- (void)setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelAWBlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter;

- (void)setText:(NSString *)text automaticWritingAnimationWithDuration:(NSTimeInterval)duration blinkingMode:(UILabelAWBlinkingMode)blinkingMode blinkingCharacter:(unichar)blinkingCharacter completion:(void (^)(void))completion;


@end
