//
//  ViewController.m
//  BFTestFramework
//
//  Created by 翁恒丛 on 2018/10/17.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"
#import <BFDynamicFramework/UIView+Frame.h>
#import <BFDynamicFramework/BFDeviceUtils.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BFDeviceUtils *utils = [[BFDeviceUtils alloc] init];
    [utils class];
    
    UIView *view = [[UIView alloc] init];
    CGFloat xy = view.xy;
    NSLog(@"xy: %f ", xy);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
