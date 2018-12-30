//
//  ViewController.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/28.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BaseDemo.h"
#import "SerialQueueDemo.h"
#import "PthreadRecuriseMutexDemo.h"

@interface ViewController ()
@property (strong, nonatomic) BaseDemo *demo;

@property (strong, nonatomic) NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseDemo *demo = [[PthreadRecuriseMutexDemo alloc] init];
    //    [demo ticketTest];
    //    [demo moneyTest];
    [demo otherTest];
    
    
    //    BaseDemo *demo2 = [[SynchronizedDemo alloc] init];
    //    [demo2 ticketTest];
    
    //    self.thread = [[NSThread alloc] initWithBlock:^{
    //        NSLog(@"111111");
    //
    //        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    //        [[NSRunLoop currentRunLoop] run];
    //    }];
    //    [self.thread start];
    
    // 线程的任务一旦执行完毕，生命周期就结束，无法再使用
    // 保住线程的命为什么要用runloop，用强指针不就好了么？
    // 准确来讲，使用runloop是为了让线程保持激活状态
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        
        [self performSelector:@selector(test) withObject:nil afterDelay:.0];
        
        NSLog(@"3");
    });
    
    // 主线程几乎所有的事情都是交给了runloop去做，比如UI界面的刷新、点击事件的处理、performSelector等等
}

- (void)test
{
    NSLog(@"2");
}


@end
