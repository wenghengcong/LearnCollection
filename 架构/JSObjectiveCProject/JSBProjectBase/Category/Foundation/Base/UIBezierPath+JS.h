//
//  UIBezierPath+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/6/6.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

// Direction
typedef enum {
    kUIBezierPathArrowDirectionNone  = 0,
    kUIBezierPathArrowDirectionRight = 1 << 0,
    kUIBezierPathArrowDirectionLeft  = 1 << 1,
    kUIBezierPathArrowDirectionUp    = 1 << 2,
    kUIBezierPathArrowDirectionDown  = 1 << 3
}UIBezierPathArrowDirection;

@interface UIBezierPath(JS)

#pragma mark- symbol

+ (UIBezierPath *)customBezierPathOfPlusSymbolWithRect:(CGRect)rect   // plus
                                                 scale:(CGFloat)scale;
+ (UIBezierPath *)customBezierPathOfMinusSymbolWithRect:(CGRect)rect  // minus
                                                  scale:(CGFloat)scale;
+ (UIBezierPath *)customBezierPathOfCheckSymbolWithRect:(CGRect)rect  // check
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick;
+ (UIBezierPath *)customBezierPathOfCrossSymbolWithRect:(CGRect)rect  // cross
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick;
+ (UIBezierPath *)customBezierPathOfArrowSymbolWithRect:(CGRect)rect  // arrow
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick
                                              direction:(UIBezierPathArrowDirection)direction;
+ (UIBezierPath *)customBezierPathOfPencilSymbolWithRect:(CGRect)rect // pencil
                                                   scale:(CGFloat)scale
                                                   thick:(CGFloat)thick;

#pragma mark- basicshapes
+ (UIBezierPath *)heartShape:(CGRect)originalFrame;
+ (UIBezierPath *)userShape:(CGRect)originalFrame;
+ (UIBezierPath *)martiniShape:(CGRect)originalFrame;
+ (UIBezierPath *)beakerShape:(CGRect)originalFrame;
+ (UIBezierPath *)starShape:(CGRect)originalFrame;
+ (UIBezierPath *)stars:(NSUInteger)numberOfStars shapeInFrame:(CGRect)originalFrame;

#pragma mark- svg
- (NSString*)toSVGString;


@end
