//
//  BFPermenantThread.m
//  线程保活—封装
//
//  Created by WengHengcong on 2018/12/24.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPermenantThread.h"

@interface BFThread : NSThread
@end

@implementation BFThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

@interface BFPermenantThread()

@property (strong, nonatomic) BFThread *innerThread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end

@implementation BFPermenantThread

#pragma mark - public methods

- (instancetype)init
{
    if (self = [super init]) {
        self.stopped = NO;
        
        __weak typeof(self) weakSelf = self;
        
        self.innerThread = [[BFThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
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
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(BFPermenantThreadTask)task
{
    task();
}

@end
