//
//  UIButton+Darg.h
//  timeboy
//
//  Created by whc on 15/6/26.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  使用方法：设置下面两个属性即可
 *  [btn1 setDragEnable:YES];
 *  [btn1 setAdsorbEnable:NO];
 */
@interface UIButton(Drag)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
