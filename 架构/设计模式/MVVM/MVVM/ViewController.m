//
//  ViewController.m
//  MVVM
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFAppViewModel.h"

@interface ViewController ()
@property (nonatomic, strong) BFAppViewModel *viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.viewModel = [[BFAppViewModel alloc] initWithController:self];
}


@end
