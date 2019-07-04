//
//  ViewController.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1;
    button.frame = CGRectMake(100, 100, 80, 40);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


@end
