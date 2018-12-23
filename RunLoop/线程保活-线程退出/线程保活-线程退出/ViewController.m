//
//  ViewController.m
//  线程保活-线程退出
//
//  Created by WengHengcong on 2018/12/23.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFThread.h"

@interface ViewController ()

@property (strong, nonatomic) BFThread *thread;

@property (assign, nonatomic, getter=isStoped) BOOL stopped;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    self.stopped = NO;
    self.thread = [[BFThread alloc] initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);
        
        // 往RunLoop里面添加Source\Timer\Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStoped) {
            NSLog(@"%@", weakSelf);
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"%@----end----", [NSThread currentThread]);
        
        // NSRunLoop的run方法是无法停止的，它专门用于开启一个永不销毁的线程（NSRunLoop）
        // 调用停止方法，也只能停止一次
        //        [[NSRunLoop currentRunLoop] run];
        /*
         it runs the receiver in the NSDefaultRunLoopMode by repeatedly invoking runMode:beforeDate:.
         In other words, this method effectively begins an infinite loop that processes data from the run loop’s input sources and timers
         */
        
    }];
    [self.thread start];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"子线程需要执行的任务 %s %@", __func__, [NSThread currentThread]);
}


/** 在子线程退出当前子线程 */
- (IBAction)threadExit:(id)sender
{
    // 在子线程调用stop
    // waitUntilDone： NO 不会等待stopThread执行完
    // YES:等待stopThread执行完
//    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

// 用于停止子线程的RunLoop
- (void)stopThread
{
    // 设置标记为YES
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    
    //为了防止崩溃，先点击停止，线程就会停止，虽然没销毁，但是已经无法执行任务了。。。。
    //点击完停止，再点击返回，就会再次向thread执行stopThread就会崩溃
    // 在子线程停止后，将子线程清空
//    self.thread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    // 在此处的self threadExit会崩溃，会出现坏内存访问。
    // 1.坏内存访问出现在这行：[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // 因为调用self threadExit，是调用[self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:NO]; 这行，这行其实本质上就是子线程RunLoop的调用，所以会在runMode中出现坏内存防范。
    // 坏内存访问的是ViewController坏内存。
    // waitUntilDone: NO，会直接运行，所以stopThread在子线程执行，同时主线程执行dealloc完毕，self其实已经销毁
    
    // 2.为解决该崩溃，需要将    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
    // waitUntilDone置为YES
    [self threadExit:nil];
}

@end
