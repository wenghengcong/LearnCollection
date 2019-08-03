//
//  ViewController.m
//  多线程
//
//  Created by Hunt on 2019/7/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread *globalThread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self interview_question_7];
}

- (void)interview_question_1
{
    // 主队列同步任务
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}

- (void)interview_question_2
{
    // 串行队列同步任务
    NSLog(@"touchesBegan begin");
    dispatch_queue_t serialQueue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        [self doSomething];
    });
    NSLog(@"touchesBegan end");
}

- (void)doSomething
{
    NSLog(@"log");
}


- (void)interview_question_3
{
    NSLog(@"1");
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_sync(globalQueue, ^{
        NSLog(@"2");
        dispatch_sync(globalQueue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)interview_question_4
{
    dispatch_queue_t global_queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    dispatch_async(global_queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
//        [self performSelector:@selector(printLog) withObject:nil];
        NSLog(@"3");
    });
}

- (void)printLog
{
    NSLog(@"2");
}

// 如何实现A、B、C任务后，执行D任务
- (void)interview_question_5
{
    dispatch_queue_t concurrent_queue = dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, concurrent_queue, ^{
        NSLog(@"A");
    });
    
    dispatch_group_async(group, concurrent_queue, ^{
        NSLog(@"B");
    });
    
    dispatch_group_async(group, concurrent_queue, ^{
        NSLog(@"C");
    });
    
    dispatch_group_notify(group, concurrent_queue, ^{
        NSLog(@"D");
    });
}

- (void)interview_question_6
{
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    
    [thread start];
    
    [self performSelector:@selector(question_6_log) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)question_6_log
{
    NSLog(@"2");
}

- (void)interview_question_7
{
//    dispatch_queue_t queue = dispatch_queue_create("com.nemo.ConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        [self testA];
//    });
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testA) object:nil];
    [thread start];
}

- (void)testA
{
    NSLog(@"%d-%@", [NSThread isMainThread], [NSThread currentThread]);
    NSLog(@"1");
    [self testB];
    NSLog(@"2");
}

- (void)testB
{
    NSLog(@"%d-%@", [NSThread isMainThread], [NSThread currentThread]);
    NSLog(@"3");
}

@end
