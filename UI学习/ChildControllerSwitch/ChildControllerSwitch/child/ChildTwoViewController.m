//
//  ChildTwoViewController.m
//  ChildControllerSwitch
//
//  Created by WengHengcong on 2018/5/17.
//  Copyright © 2018年 LuCi. All rights reserved.
//

#import "ChildTwoViewController.h"

@interface ChildTwoViewController ()

@end

@implementation ChildTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MessageCenter";
    UIButton *redButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
    [redButton setTitle:@"Child Two" forState:UIControlStateNormal];
    redButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:redButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"child two viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"child two viewWillDisappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"child two viewDidAppear");
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
