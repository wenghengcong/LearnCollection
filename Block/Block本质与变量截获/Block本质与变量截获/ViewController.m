//
//  ViewController.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "CaptureAutoBlock.h"
#import "CaptureSelfBlock.h"
#import "CaptureStaticBlock.h"
#import "CaptureGlobalBlock.h"

@interface ViewController ()

@property (nonatomic, strong) CaptureAutoBlock *autoBlock;
@property (nonatomic, strong) CaptureSelfBlock *selfBlock;
@property (nonatomic, strong) CaptureStaticBlock *staticBlock;
@property (nonatomic, strong) CaptureGlobalBlock *globalBlock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.autoBlock = [[CaptureAutoBlock alloc] init];
    self.selfBlock = [[CaptureSelfBlock alloc] init];
    self.staticBlock = [[CaptureStaticBlock alloc] init];
    self.globalBlock = [[CaptureGlobalBlock alloc] init];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.autoBlock test];
//    [self.selfBlock test];
//    [self.staticBlock test];
//    [self.globalBlock test];
}

@end
