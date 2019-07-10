//
//  ThridViewController.m
//  NSTimerBestPractice
//
//  Created by Hunt on 2019/7/10.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ThridViewController.h"
#import "NSTimer+Block.h"

@interface ThridViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ThridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self testTimer];
}

- (void)testTimer
{
    // 1. 这种情况下，会造成循环引用，Timer的Block对self是强引用，self对Timer也是强引用
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self task];
//    }];

    
    // 2. 这种情况下，会造成循环引用。不管传入的target是强引用还是弱引用，都是将self引用传入，内部都是强引用
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                  target:self
//                                                selector:@selector(task)
//                                                userInfo:nil repeats:YES];

    
    
    // 解决循环引用： 这种情况下，Block对self是弱引用，是可以避免循环引用的
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        [weakSelf task];
    } repeats:YES];
    
}

- (void)task
{
    NSLog(@"%s : %@", __func__, [NSThread currentThread]);
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"%s", __func__);
}

@end
