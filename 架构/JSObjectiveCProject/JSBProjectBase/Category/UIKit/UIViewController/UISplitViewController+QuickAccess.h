//
//  UISplitViewController+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UISplitViewController(QuickAccess)

#pragma mark- QuickAccess
@property (weak, readonly, nonatomic) UIViewController * leftController;
@property (weak, readonly, nonatomic) UIViewController * rightController;

@end
