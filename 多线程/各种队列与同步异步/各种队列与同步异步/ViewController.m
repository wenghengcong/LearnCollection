//
//  ViewController.m
//  各种队列与同步异步
//
//  Created by WengHengcong on 2018/12/28.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self asyncOperationsOnConcurrentThread];
}

/**
 主队列-同步：崩溃
 提交到主队列，syncOperationMainThread、任务1
 主队列在主线程执行，任务1执行，必须先要执行完syncOperationMainThread
 但是，syncOperationMainThread执行完毕，又要依赖任务1执行完，两者互相等待
 */
-(void)syncOperationMainThread {
    dispatch_queue_t q = dispatch_get_main_queue();
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        dispatch_sync(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}
/**
 主队列-异步
 提交到主队列，所以是asyncOperationsOnMainThread，任务1
 主队列在主线程执行，执行syncOperationMainThread，其中遇到任务1
 由于任务1是异步提交的，所以不需要等待任务1返回，可以继续syncOperationMainThread
 执行完syncOperationMainThread，继续执行异步提交的任务1
 */
- (void)asyncOperationsOnMainThread {
    NSLog(@"------------Start------------");
    dispatch_queue_t q = dispatch_get_main_queue();
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 全局队列-同步
 提交到全局队列，所以是asyncOperationsOnMainThread，任务1
 由于是全局队列，是个并发队列，也就是可以多个任务并发执行。
 但是任务1是同步提交，所以要等待任务1执行完之后，才能执行asyncOperationsOnMainThread
 */
- (void)syncOperationsOnGloabThread {
    NSLog(@"------------Start------------");
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; ++i) {
        dispatch_sync(q, ^{
            // [NSThread currentThread] 此处打印{number = 1, name = main}
            // As an optimization, this function invokes the block on the current thread when possible.
            // 由于优化，会将任务1在主线程执行
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 全局队列-异步
 在主线程执行asyncOperationsOnGloabThread
 将任务1提交到全局队列，并且以异步方式提交。
 异步提交后，继续执行asyncOperationsOnGloabThread
 之后开始执行任务1，并且全局队列会调度多个新线程并发执行任务1
 */
- (void)asyncOperationsOnGloabThread {
    NSLog(@"------------Start------------");
    dispatch_queue_t q = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 串行队列-同步
 主线程执行syncOperationsOnSerialThread
 将任务1同步提交到一个串行队列，由于是同步，提交任务1后，需要等待执行完
 任务1执行完，回到主线程继续执行syncOperationsOnSerialThread
 由于优化，同步任务会直接调度在主线程完成
 */
- (void)syncOperationsOnSerialThread {
    dispatch_queue_t q = dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_sync(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 串行队列-异步
 主线程执行asyncOperationsOnSerialThread
 将任务1异步提交到串行队列
 由于是异步提交，回到主线程继续执行asyncOperationsOnSerialThread
 串行队列分派新线程执行任务1
 */
- (void)asyncOperationsOnSerialThread {
    dispatch_queue_t q = dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 并发队列-同步
 执行syncOperationsOnConcurrentThread
 同步提交任务1到并发队列，由于是同步，将会等待任务1执行完毕
 并且由于优化，将同步任务分配到主线程执行
 执行完任务1后，继续执行syncOperationsOnConcurrentThread
 */
- (void)syncOperationsOnConcurrentThread {
    dispatch_queue_t q = dispatch_queue_create("concurrent",DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_sync(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 并发队列-异步
 执行asyncOperationsOnConcurrentThread
 异步提交任务1到并发队列，由于异步提交，将会继续执行asyncOperationsOnConcurrentThread
 执行完后，并发队列将任务1分配到多个线程执行任务1
 */
- (void)asyncOperationsOnConcurrentThread {
    dispatch_queue_t q = dispatch_queue_create("concurrent",DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        // 同步任务顺序执行
        dispatch_async(q, ^{
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}


@end
