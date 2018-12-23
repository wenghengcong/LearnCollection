//
//  BFPermenantThread2.m
//  线程保活—封装
//
//  Created by WengHengcong on 2018/12/24.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPermenantThread2.h"

@interface BFThread : NSThread
@end

@implementation BFThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

@interface BFPermenantThread2()

@property (strong, nonatomic) BFThread *innerThread;

@end

@implementation BFPermenantThread2

#pragma mark - public methods

- (instancetype)init
{
    if (self = [super init]) {
        
        self.innerThread = [[BFThread alloc] initWithBlock:^{
            NSLog(@"begin----");
            
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            //            while (weakSelf && !weakSelf.isStopped) {
            //                // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
            //                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
            //            }
        }];
        
        [self.innerThread start];
    }
    return self;
}

//- (void)run
//{
//    if (!self.innerThread) return;
//
//    [self.innerThread start];
//}

- (void)executeTask:(BFPermenantThreadTask)task
{
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark - private methods
- (void)__stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(BFPermenantThreadTask)task
{
    task();
}


@end

