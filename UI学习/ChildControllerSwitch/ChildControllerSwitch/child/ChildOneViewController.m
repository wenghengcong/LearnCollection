//
//  ChildOneViewController.m
//  ChildControllerSwitch
//
//  Created by WengHengcong on 2018/5/17.
//  Copyright © 2018年 LuCi. All rights reserved.
//

#import "ChildOneViewController.h"

@interface ChildOneViewController ()

@end

@implementation ChildOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    UIButton *greenButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    [greenButton setTitle:@"Child One" forState:UIControlStateNormal];
    greenButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"child one viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"child one viewWillDisappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"child one viewDidAppear");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
