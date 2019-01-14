//
//  UIView+JSB.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JSB)


#pragma mark - position attribute

/***  frame.origin.x    */
@property (nonatomic) CGFloat left;

/***  frame.origin.y    */
@property (nonatomic) CGFloat top;

/***  frame.origin.x + frame.size.width    */
@property (nonatomic) CGFloat right;

/***  frame.origin.y + frame.size.height    */
@property (nonatomic) CGFloat bottom;

/***  frame.size.width  */
@property (nonatomic) CGFloat width;

/***  frame.size.height */
@property (nonatomic) CGFloat height;

/***  center.x  */
@property (nonatomic) CGFloat centerX;

/***  center.y  */
@property (nonatomic) CGFloat centerY;

/***  frame.origin  */
@property (nonatomic) CGPoint origin;

/***  frame.size    */
@property (nonatomic) CGSize  size;

- (CGFloat)topCenterWith:(UIView *)v;


#pragma mark - draw border

enum JSBorderPosition {
    JSBorderPositionTop,
    JSBorderPositionBottom,
    JSBorderPositionLeft,
    JSBorderPositionRight
};

/**
 *  添加边框:四边
 */
- (void)addOneRetinaPixelBorder;
- (void)addOneRetinaPixelBorderWithColor:(UIColor*)color andRadius:(CGFloat)radius;
- (void)addBorderWithColor:(UIColor *)color andWidth:(float)lineWidth andRadius:(CGFloat)radius;
/**
 *  添加1px边框：一边
 *
 *  @param position 需要添加边框的一边
 */
- (void)addOneRetinaPixelLineAtPosition:(enum JSBorderPosition)position;
- (void)addOneRetinaPixelLineWithColor:(UIColor*)color atPosition:(enum JSBorderPosition)position;
/**
 *  添加边框：一边
 *
 *  @param position 需要添加边框的一边
 */
- (void)addLineWithWidth:(float)lineWidth atPosition:(enum JSBorderPosition)position;
- (void)addLineWithColor:(UIColor*)color andWidth:(float)lineWidth atPosition:(enum JSBorderPosition)position;
/**
 *  移除边框
 */
- (void)removeBorderAtPosition:(enum JSBorderPosition)position;
- (void)removeAllBorders;

#pragma mark - add/remove subviews
/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;
/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views;

/**
 *  移除视图内的所有子视图，比上面方法更好
 */
+ (void)removeAllSubviews:(UIView *)superview;

#pragma mark - other

- (UIImage *)screenshot;
                                         
@end
