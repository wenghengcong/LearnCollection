//
//  ViewController.m
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFProxyOfNSObject.h"
#import "BFProxy.h"

@interface ViewController ()

@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self testDisplayLink];
    [self testTimer];
}

- (void)testDisplayLink
{
    // 也是一个定时器，不用设置时间，调用频率和屏幕的刷帧频率一致，60FPS
    // 会造成循环引用，link对self强引用，self对link强引用
//    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(task)];
//    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 解决循环引用
    // self对self.link强引用，self.link对BFProxyOfNSObject强引用，BFProxyOfNSObject对self弱引用，搭建了个三角循环
    // 当控制器销毁时，没有其他强引用，即可避免循环引用
    self.link = [CADisplayLink displayLinkWithTarget:[BFProxyOfNSObject proxyWithTarget:self] selector:@selector(task)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
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
//
    // 解决循环引用： 这种情况下，Block对self是弱引用，是可以避免循环引用的
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf task];
//    }];
    
    // 解决循环引用：
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:[BFProxy proxyWithTarget:self]
                                                selector:@selector(task)
                                                userInfo:nil repeats:YES];

}

- (void)task
{
    NSLog(@"%s : %@", __func__, [NSThread currentThread]);
}

- (void)dealloc
{
    [self.link invalidate];
    self.link = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"%s", __func__);
}

@end
