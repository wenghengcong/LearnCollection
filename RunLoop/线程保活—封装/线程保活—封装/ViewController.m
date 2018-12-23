//
//  ViewController.m
//  线程保活—封装
//
//  Created by WengHengcong on 2018/12/23.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPermenantThread.h"

@interface ViewController ()
@property (strong, nonatomic) BFPermenantThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[BFPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
    
    // AFN 2.X 版本
    // 串行
    // 非并发
}

- (IBAction)stop:(id)sender {
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
