//
//  ViewController.m
//  HitTesting
//
//  Created by Nemo on 2024/9/4.
//

#import "ViewController.h"
#import "CustomButton.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [button addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    
}

- (void)testClick {
    NSLog(@"click button");
}


@end
