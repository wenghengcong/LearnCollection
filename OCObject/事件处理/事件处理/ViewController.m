//
//  ViewController.m
//  事件处理
//
//  Created by Hunt on 2019/5/9.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.tapGestureView addGestureRecognizer:ges];
}

- (void)tapView
{
    NSLog(@"-----");
    
    [self.view hitTest:CGPointZero withEvent:UIEvent];
}

- (IBAction)clickButton:(id)sender {
    NSLog(@"-----");
}



@end
