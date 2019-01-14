//
//  UIActivityIndicatorViewUsage.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/11.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "UIActivityIndicatorViewUsage.h"

@interface UIActivityIndicatorViewUsage()

@property (nonatomic ,strong)UIActivityIndicatorView        *indicatorView;

@end

@implementation UIActivityIndicatorViewUsage

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)uivu_initView {
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    //设置样式
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.indicatorView.center = CGPointMake(SWidth/2, 90);
    //    self.lindicatorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.indicatorView];
    
}

/**
 *  stop indicator
 */
- (void)uivu_stopView {
    
    [self.indicatorView stopAnimating];
}
/**
 *  start indicator
 */
- (void)uivu_startView {
    
    if (![self.indicatorView isAnimating]) {
        [self.indicatorView startAnimating];
    }
}

@end
