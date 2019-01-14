//
//  UINavigationController+Transitions.h
//  CategoryCollection
//
//  Created by whc on 15/7/23.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(Transitions)


#pragma mark - back transitions
- (void)pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition;
- (UIViewController *)popViewControllerWithTransition:(UIViewAnimationTransition)transition;


@end
