//
//  UIButton+JS.m
//  timeboy
//
//  Created by whc on 15/5/12.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIButton+JS.h"
#import <objc/runtime.h>

// Associative reference keys.
static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";

@interface UIButton ()

@property(nonatomic, strong) UIView *modalView;
@property(nonatomic, strong) UIActivityIndicatorView *spinnerView;
@property(nonatomic, strong) UILabel *spinnerTitleLabel;

@end

@implementation UIButton(JS)

#pragma mark- 创建按钮

/**
 *  创建一个普通的圆角按钮
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize BackgroundColor:(UIColor *)bgcolor Frame:(CGRect)rect Radius:(BOOL)isRadius
{
    self = [super init];
    if (self) {
        self.frame = rect;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateHighlighted];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        [self setBackgroundImage: [UIImage imageWithColor:bgcolor andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [self setBackgroundImage: [UIImage imageWithColor:bgcolor andSize:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        
        if (isRadius) {
            [self addOneRetinaPixelBorderWithColor:titleColor andRadius:kMidRadius];
        }
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize BackgroundColor:(UIColor *)bgcolor Radius:(BOOL)isRadius
{
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateHighlighted];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:fontsize];
        
        [self setBackgroundColor:bgcolor forState:UIControlStateNormal];
        [self setBackgroundColor:bgcolor forState:UIControlStateHighlighted];
        
        if (isRadius) {
            [self addOneRetinaPixelBorderWithColor:titleColor andRadius:kMidRadius];
        }
    }
    
    return self;
}

/**
 *  创建一个带颜色的圆角按钮，圆角颜色同一般和titleColor一致，按钮背景色默认白色
 */
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize Frame:(CGRect)rect;
{
    
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:[UIColor whiteColor] Frame:rect Radius:YES];
    return  self;
}
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize ;
{
    
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:[UIColor whiteColor] Radius:YES];
    return  self;
}

/**
 *  创建一个带颜色的圆角按钮，圆角颜色同一般和titleColor一致，可自定义背景色
 */
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize Frame:(CGRect)rect
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:backcolor Frame:rect Radius:YES];
    return  self;
}
- (id)initRadiusButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:backcolor Radius:YES];
    return  self;
}



/**
 *  创建一个不带圆角和边框的有颜色的按钮，按钮背景为白色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize Frame:(CGRect)rect
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:[UIColor whiteColor] Frame:rect Radius:NO];
    return  self;
    
}
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor FontSize:(CGFloat)fontsize
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:[UIColor whiteColor]  Radius:NO];
    return  self;
    
}
/**
 *  创建一个不带圆角和边框的有颜色的按钮，可设按钮背景色
 */
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize Frame:(CGRect)rect
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:backcolor Frame:rect Radius:NO];
    return  self;
    
}
- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor  BackgroundColor:(UIColor *)backcolor FontSize:(CGFloat)fontsize
{
    self = [self initWithTitle:title titleColor:titleColor FontSize:fontsize BackgroundColor:backcolor Radius:NO];
    return  self;
    
}

#pragma mark- 按钮设置

/**
 *  设置圆形按钮
 */
- (void)setRadius:(CGFloat)radius Color:(UIColor *)color
{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = kScreenResolutionOne;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

-(void)reverseTitleAndImagePosition
{
    self.transform = CGAffineTransformScale(self.transform, -1.0f, 1.0f);
    self.titleLabel.transform = CGAffineTransformScale(self.titleLabel.transform, -1.0f, 1.0f);
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, -1.0f, 1.0f);
}

#pragma makr- indicator

- (void) showIndicator {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
    
    
}

- (void) hideIndicator {
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
    
}

#pragma mark- countdown

-(void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle{
    __block NSInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark- block


#pragma mark- backgroundcolor

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor andSize:CGSizeMake(1, 1)] forState:state];
}

#pragma mark- submiting

- (void)beginSubmitting:(NSString *)title {
    [self endSubmitting];
    
    self.submitting = @YES;
    self.hidden = YES;
    
    self.modalView = [[UIView alloc] initWithFrame:self.frame];
    self.modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.modalView.layer.borderWidth = self.layer.borderWidth;
    self.modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.modalView.bounds;
    self.spinnerView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.spinnerView.bounds;
    self.spinnerView.frame = CGRectMake(
                                        15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                        spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.spinnerTitleLabel.text = title;
    self.spinnerTitleLabel.font = self.titleLabel.font;
    self.spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.modalView addSubview:self.spinnerView];
    [self.modalView addSubview:self.spinnerTitleLabel];
    [self.superview addSubview:self.modalView];
    [self.spinnerView startAnimating];
}

- (void)endSubmitting {
    if (!self.isSubmitting.boolValue) {
        return;
    }
    
    self.submitting = @NO;
    self.hidden = NO;
    
    [self.modalView removeFromSuperview];
    self.modalView = nil;
    self.spinnerView = nil;
    self.spinnerTitleLabel = nil;
}

- (NSNumber *)isSubmitting {
    return objc_getAssociatedObject(self, @selector(setSubmitting:));
}

- (void)setSubmitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setSubmitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIActivityIndicatorView *)spinnerView {
    return objc_getAssociatedObject(self, @selector(setSpinnerView:));
}

- (void)setSpinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setSpinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)modalView {
    return objc_getAssociatedObject(self, @selector(setModalView:));
    
}

- (void)setModalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setModalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setSpinnerTitleLabel:));
}

- (void)setSpinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setSpinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
