//
//  UIView+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

enum JSBorderPosition {
    JSBorderPositionTop,
    JSBorderPositionBottom,
    JSBorderPositionLeft,
    JSBorderPositionRight
};

float radiansForDegrees(int degrees);

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);


@interface UIView(JS)

#pragma mark- frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic,assign) CGFloat radius;

#pragma mark- 边框
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

/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;



#pragma mark- 移除视图
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

#pragma mark- 分割线

/**
 *  获取tableviewcell的底部分割线
 */
- (UIView *)initTableCellBottomLineView;
/**
 *  获取tableviewcell(左边带有icon)的底部分割线，一般用于设置中
 */
- (UIView *)initTableImgaeCellBottomLineView;
/**
 *  获取tableviewcell的底部分割线，屏幕宽度
 */
- (UIView *)initTableCellFullBottomLineView;
/**
 *  获取tableviewcell的顶部分割线
 */
- (UIView *)initTableCellTopLineView;
/**
 *  获取tableviewcell的顶部分割线，屏幕宽度
 */
- (UIView *)initTableCellFullTopLineView;

/**
 *  初始化一条灰线
 */
+ (UIView *)lineView;
+ (UIView *)lineViewWithFrame:(CGRect)frame;

#pragma mark- animation

// Moves
- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method;
- (void)raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack;
- (void)raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method;

// Transforms
- (void)rotate:(int)degrees secs:(float)secs delegate:(id)delegate callback:(SEL)method;
- (void)scale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method;
- (void)spinClockwise:(float)secs;
- (void)spinCounterClockwise:(float)secs;

// Transitions
- (void)curlDown:(float)secs;
- (void)curlUpAndAway:(float)secs;
- (void)drainAway:(float)secs;

// Effects
- (void)changeAlpha:(float)newAlpha secs:(float)secs;
- (void)pulse:(float)secs continuously:(BOOL)continuously;

//add subview
- (void)addSubviewWithFadeAnimation:(UIView *)subview;


#pragma mark- debug
#pragma mark- frame
#pragma mark- nib

+ (UINib *)loadNib;
+ (UINib *)loadNibNamed:(NSString*)nibName;
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;
+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

#pragma mark- recursivedescription
/**
 *  打印视图层级
 */
-(NSString*)recursiveView;
/**
 *  打印约束
 */
-(NSString*)constraintsDescription;
/**
 *  打印整个视图树的字符串
 */
-(NSString*)autolayoutTraceDescription;

#pragma mark- block gesture

- (void)addTapActionWithBlock:(GestureActionBlock)block;
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;

#pragma mark- screenshot
- (UIImage *)screenshot;


#pragma mark- find
- (id)findSubViewWithSubViewClass:(Class)clazz;
- (id)findsuperViewWithSuperViewClass:(Class)clazz;

- (BOOL)findAndResignFirstResponder;
- (UIView *)findFirstResponder;


#pragma mark- viewcontroller

@property (readonly) UIViewController *viewController;

#pragma mark- constraints
- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute;

- (NSLayoutConstraint *)leftConstraint;
- (NSLayoutConstraint *)rightConstraint;
- (NSLayoutConstraint *)topConstraint;
- (NSLayoutConstraint *)bottomConstraint;
- (NSLayoutConstraint *)leadingConstraint;
- (NSLayoutConstraint *)trailingConstraint;
- (NSLayoutConstraint *)widthConstraint;
- (NSLayoutConstraint *)heightConstraint;
- (NSLayoutConstraint *)centerXConstraint;
- (NSLayoutConstraint *)centerYConstraint;
- (NSLayoutConstraint *)baseLineConstraint;

@end
