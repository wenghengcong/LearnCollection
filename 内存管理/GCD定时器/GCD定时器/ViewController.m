//
//  ViewController.m
//  GCD定时器
//
//  Created by WengHengcong on 2019/1/7.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFTimer.h"

@interface ViewController ()

@property (strong, nonatomic) dispatch_source_t timer;
@property (copy, nonatomic) NSString *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    [self testGCDTimer];
    
//    self.task = [BFTimer execTask:^{
//        NSLog(@"封装的定时器");
//    } start:2.0 interval:1.0 repeats:YES async:YES];
    
    self.task = [BFTimer execTask:self selector:@selector(execuTask) start:2.0 interval:1.0 repeats:YES async:YES];
}



- (void)testGCDTimer
{
    // 创建队列
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
    // 设置定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    uint64_t start = 2.0;       // 2s后开始执行
    uint64_t interval = 1.0;    // 每隔1s循环
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"定时器触发 - %@", [NSThread currentThread]);
    });
    
//    dispatch_source_set_event_handler_f(timer, timerFire);
    
    // 启动定时器
    dispatch_resume(timer);
    
    //只有保留timer，timer才能执行
    self.timer = timer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (self.timer) {
//        // 暂停timer
//        dispatch_suspend(self.timer);
//    }
    
    // 取消封装定时器
    [BFTimer cancelTask:self.task];
}

void timerFire(void *param)
{
    NSLog(@"定时器触发 - %@", [NSThread currentThread]);
}

- (void)execuTask
{
    NSLog(@"execuTask - %@", [NSThread currentThread]);
}

@end
