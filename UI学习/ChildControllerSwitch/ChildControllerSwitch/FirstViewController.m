//
//  FirstViewController.m
//  ChildControllerSwitch
//
//  Created by WengHengcong on 2018/5/17.
//  Copyright © 2018年 LuCi. All rights reserved.
//

#import "FirstViewController.h"
#import "ChildOneViewController.h"
#import "ChildTwoViewController.h"

@interface FirstViewController ()

@property (nonatomic, assign) BOOL              gary;

@end

@implementation FirstViewController
/*
 
 https://imliaoyuan.com/2016/08/30/%E5%A6%82%E4%BD%95%E6%AD%A3%E7%A1%AE%E6%B7%BB%E5%8A%A0child_view_controller
 
 1.添加一个 child view controller
 
 UIViewController *vc = [UIViewController new];
 [self addChildViewController:vc]; // 把vc作为当前viewcontrller的子控制器
 // config vc.
 [self.view addSubview:vc.view]; // 把vc的view添加到父控制器上面
 [vc didMoveToParentViewController:self];  // 子vc被通知现在有了一个父控制器
 
 2. 移除一个 child view controller
 [vc willMoveToParentViewController:nil];
 [vc.view removeFromSuperview];
 [vc removeFromParentViewController];
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gary = NO;
    if (_gary) {
        ChildOneViewController *oneVc = [[ChildOneViewController alloc] init];
        [self addChildViewController:oneVc];
        [self.view addSubview:oneVc.view];
        [oneVc didMoveToParentViewController:self];
    } else {
        ChildTwoViewController *twoVc = [[ChildTwoViewController alloc] init];
        [self addChildViewController:twoVc];
        [self.view addSubview:twoVc.view];
        [twoVc didMoveToParentViewController:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
