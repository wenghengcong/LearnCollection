//
//  ViewController.m
//  线程保活
//
//  Created by WengHengcong on 2018/12/21.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFThread.h"

@interface ViewController ()

@property (strong, nonatomic) BFThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 线程一启动，就会在线程thread中执行self的run方法
    self.thread = [[BFThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"执行子线程任务 %s %@", __func__, [NSThread currentThread]);
}

// 这个方法的目的：线程保活
- (void)run {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    
    // 往RunLoop里面添加Source\Timer\Observer
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"%s ----end----", __func__);
}


@end
