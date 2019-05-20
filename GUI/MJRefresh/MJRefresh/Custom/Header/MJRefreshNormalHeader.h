//
//  MJRefreshNormalHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshStateHeader.h"



/**
 默认的下拉刷新控件
 */
@interface MJRefreshNormalHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;

/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
