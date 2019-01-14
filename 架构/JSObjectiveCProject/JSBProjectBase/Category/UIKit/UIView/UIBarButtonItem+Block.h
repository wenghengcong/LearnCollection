//
//  UIBarButtonItem+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem(Block)

#pragma mark- action
typedef void (^BarButtonActionBlock)();
- (void)setActionBlock:(BarButtonActionBlock)actionBlock;


@end
