//
//  UINavigationController+StackControl.h
//  CategoryCollection
//
//  Created by whc on 15/7/27.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(StackControl)


- (id)findViewController:(NSString*)className;
- (BOOL)isOnlyContainRootViewController;
- (UIViewController *)rootViewController;
- (NSArray *)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;


@end
