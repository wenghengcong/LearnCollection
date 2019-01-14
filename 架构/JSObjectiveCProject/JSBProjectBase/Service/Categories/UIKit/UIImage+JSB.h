//
//  UIImage+Clip.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JSB)

+ (UIImage *)reduce:(UIImage *)image withMaxSize:(CGSize) maxSize;

@end
