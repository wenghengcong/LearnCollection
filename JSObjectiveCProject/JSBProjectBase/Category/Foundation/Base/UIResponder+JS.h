//
//  UIResponder+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIResponder(JS)

#pragma mark- chain
- (NSString *)responderChainDescription;

#pragma mark- UIAdapt
CGRect CGAdaptRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
CGPoint CGAdaptPointMake(CGFloat x, CGFloat y);
-(CGFloat)factorAdapt;

@end
