//
//  UIView+JSB.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/16.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "UIView+JSB.h"

@implementation UIView (JSB)


#pragma mark - position attribute

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)topCenterWith:(UIView *)v
{
    return v.top+(v.height-self.height)/2;
}

#pragma mark - draw border

#pragma mark  four sider border

static UIColor* _defaultBorderColor;

- (void)setDefaultBorderColor:(UIColor *)defaultBorderColor {
    _defaultBorderColor = defaultBorderColor;
}

- (UIColor *)defaultBorderColor {
    if (!_defaultBorderColor) {
        if ([self respondsToSelector:@selector(tintColor)]) {
            return self.tintColor;
        } else {
            return [UIColor blueColor];
        }
    } else {
        return _defaultBorderColor;
    }
}

- (void)addOneRetinaPixelBorder {
    double retinaPixelSize = 1./[UIScreen mainScreen].scale;
    [self addOneRetinaPixelBorderWithColor:self.defaultBorderColor radius:retinaPixelSize];
}

- (void)addOneRetinaPixelBorderWithColor:(UIColor*)color radius:(CGFloat)radius{
    double retinaPixelSize = 1./[UIScreen mainScreen].scale;
    [self addBorderWithColor:color width:retinaPixelSize radius:radius];
}

- (void)addBorderWithColor:(UIColor *)color width:(float)lineWidth radius:(CGFloat)radius{
    self.layer.borderWidth = lineWidth;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

#pragma mark  single side border

- (void)addOneRetinaPixelLineAtPosition:(enum JSBorderPosition)position {
    [self addOneRetinaPixelLineWithColor:self.defaultBorderColor atPosition:position];
}

- (void)addOneRetinaPixelLineWithColor:(UIColor*)color atPosition:(enum JSBorderPosition)position {
    
    double retinaPixelSize = 1./[UIScreen mainScreen].scale;
    [self addLineWithColor:color width:retinaPixelSize atPosition:position];
}

- (void)addLineWithWidth:(float)lineWidth atPosition:(enum JSBorderPosition)position {
    [self addLineWithColor:self.defaultBorderColor width:lineWidth atPosition:position];
}

- (void)addLineWithColor:(UIColor*)color width:(float)lineWidth atPosition:(enum JSBorderPosition)position {
    
    // min lineweight is one logical device pixel
    double retinaPixelSize = 1./[UIScreen mainScreen].scale;
    lineWidth = MAX(retinaPixelSize, lineWidth);
    
    CALayer *border = [CALayer layer];
    switch (position) {
        case JSBorderPositionTop:
            border.frame = CGRectMake(0, 0, self.frame.size.width, lineWidth);
            break;
            
        case JSBorderPositionBottom:
            border.frame = CGRectMake(0, self.frame.size.height-lineWidth, self.frame.size.width, lineWidth);
            break;
            
        case JSBorderPositionLeft:
            border.frame = CGRectMake(0, 0, lineWidth, self.frame.size.height);
            break;
            
        case JSBorderPositionRight:
            border.frame = CGRectMake(self.frame.size.width-lineWidth, 0, lineWidth, self.frame.size.height);
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self removeBorderAtPosition:position];
    [border setValue:@([self tagForPosition:position]) forKey:@"tag"];
    [self.layer addSublayer:border];
}


- (int)tagForPosition:(enum JSBorderPosition)position {
    
    int tag = 32147582;
    
    switch (position) {
        case JSBorderPositionTop:    return tag;
        case JSBorderPositionBottom: return tag + 1;
        case JSBorderPositionLeft:   return tag + 2;
        case JSBorderPositionRight:  return tag + 3;
    }
    
    NSAssert(NO, @"invalid position");
    return 0;
}

- (void)removeBorderAtPosition:(enum JSBorderPosition)position {
    
    int tag = [self tagForPosition:position];
    
    __block CALayer *toRemove;
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
        if ([[layer valueForKey:@"tag"] intValue] == tag) {
            *stop = YES;
            toRemove = layer;
        }
    }];
    
    [toRemove removeFromSuperlayer];
}
#pragma mark - add/remove subviews

- (void)removeAllBorders {
    
    [self removeBorderAtPosition:JSBorderPositionTop];
    [self removeBorderAtPosition:JSBorderPositionBottom];
    [self removeBorderAtPosition:JSBorderPositionLeft];
    [self removeBorderAtPosition:JSBorderPositionRight];
}


-(void)addSubviewsWithArray:(NSArray *)subViews{
    
    for (UIView *view in subViews) {
        
        [self addSubview:view];
    }
}

/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
    });
}

+(void)removeAllSubviews:(UIView *)superview
{
    [[superview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - other 

- (UIImage *)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end
