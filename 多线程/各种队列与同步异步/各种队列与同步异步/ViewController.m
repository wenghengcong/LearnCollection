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
    [self syncOperationsOnSerialThread];
}

//- (void)testLog
//{
//    NSLog(@"2");
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSThread *thread = [[NSThread alloc] initWithBlock:^{
//        NSLog(@"1");
//    }];
//    [thread start];
//    [self performSelector:@selector(testLog) onThread:thread withObject:nil waitUntilDone:YES];
//}

/**
 主队列-同步：崩溃
 1. 依次将任务提交到主队列：syncOperationMainThread、任务1；
 2. 在主线程先执行syncOperationMainThread，其内部需要执行任务1；
 3. 但执行任务1，根据串行队列的特点，又需要执行完syncOperationMainThread；
 4. 相互依赖对方执行完才能继续执行，产生死锁，崩溃。
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
 1. 依次提交任务到主队列，所以是asyncOperationsOnMainThread，任务1；
 2. 主队列在主线程执行，执行syncOperationMainThread，其中遇到任务1；
 3. 由于任务1是异步提交的，所以不需要等待任务1返回，可以继续asyncOperationsOnMainThread；
 4. 执行完asyncOperationsOnMainThread，继续在主线程执行异步提交的任务1。
 ------------Start------------
 ------------End------------
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 0
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 1
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 2
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 3
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 4
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 5
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 6
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 7
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 8
 任务1 - <_NSMainThread: 0x6000017040c0>{number = 1, name = main} - 9
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
 1. 在主线程执行syncOperationsOnGloabThread；
 2. 将任务1提交到全局队列，遇到任务1，由于是同步提交，需要立即执行任务1，阻塞当前主线程；
    2.1 原本任务1提交全局队列，是个并发队列，也就是任务1原本可以在多个线程并发执行，但由于同步需要单个任务串行执行；
    2.2 而且由于同步操作的优化，原本任务1会在主线程之外的新进程串行进行，此处也会优化成在主线程执行；
 3. 待任务1执行完之后，继续执行syncOperationsOnGloabThread；
 ------------Start------------
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 0
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 1
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 2
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 3
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 4
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 5
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 6
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 7
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 8
 任务1 - <_NSMainThread: 0x600001708000>{number = 1, name = main} - 9
 ------------End------------
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
 1. 在主线程执行asyncOperationsOnGloabThread；
 2. 将任务1提交到全局队列，并且以异步方式提交，立即会在其他线程执行任务1；
 3. 继续执行asyncOperationsOnGloabThread；
 4. 继续执行任务1，并且全局队列会调度多个新线程并发执行任务1。
 ------------Start------------
 任务1 - <NSThread: 0x600001702b80>{number = 8, name = (null)} - 0
 任务1 - <NSThread: 0x600001702c00>{number = 7, name = (null)} - 1
 任务1 - <NSThread: 0x600001758cc0>{number = 9, name = (null)} - 4
 ------------End------------
 任务1 - <NSThread: 0x600001702b80>{number = 8, name = (null)} - 5
 任务1 - <NSThread: 0x600001758cc0>{number = 9, name = (null)} - 9
 任务1 - <NSThread: 0x600001759080>{number = 10, name = (null)} - 3
 任务1 - <NSThread: 0x600001758800>{number = 13, name = (null)} - 2
 任务1 - <NSThread: 0x600001758080>{number = 12, name = (null)} - 6
 任务1 - <NSThread: 0x600001702c00>{number = 7, name = (null)} - 7
 任务1 - <NSThread: 0x600001753900>{number = 11, name = (null)} - 8
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
 1. 主线程执行syncOperationsOnSerialThread；
 2. 将任务1同步提交到一个串行队列"serial"，队列"serial"，由于同步任务不会创建新线程，所以在主线程执行任务1，由于是同步，需要等待执行完；
 3. 任务1执行完，回到主线程继续执行syncOperationsOnSerialThread。
 ------------Start------------
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 0
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 1
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 2
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 3
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 4
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 5
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 6
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 7
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 8
 任务1 - <_NSMainThread: 0x600001700000>{number = 1, name = main} - 9
 ------------End------------
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
 1. 主线程执行asyncOperationsOnSerialThread;
 2. 将任务1异步提交到串行队列，队列将分配新线程执行任务1，由于是异步提交，无须立即返回结果和等待。
   回到主线程继续执行asyncOperationsOnSerialThread；
 3. 执行完asyncOperationsOnSerialThread，新线程依次执行任务1；
 ------------Start------------
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 0
 ------------End------------
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 1
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 2
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 3
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 4
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 5
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 6
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 7
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 8
 任务1 - <NSThread: 0x600001767200>{number = 6, name = (null)} - 9
 */
- (void)asyncOperationsOnSerialThread {
    dispatch_queue_t q = dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
    NSLog(@"------------Start------------");
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            sleep(2);
            NSLog(@"任务1 - %@ - %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"------------End------------");
}

/**
 并发队列-同步
 1. 执行syncOperationsOnConcurrentThread;
 2. 同步提交任务1到并发队列，由于是同步，将会等待任务1执行完毕;
 3. 并且由于优化，将同步任务分配到主线程执行;
 4. 执行完任务1后，继续执行syncOperationsOnConcurrentThread。
 ------------Start------------
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 0
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 1
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 2
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 3
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 4
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 5
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 6
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 7
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 8
 任务1 - <_NSMainThread: 0x6000017080c0>{number = 1, name = main} - 9
 ------------End------------
 */
- (void)syncOperationsOnConcurrentThread {
    dispatch_queue_t q = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
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
 1. 执行asyncOperationsOnConcurrentThread
 2. 异步提交任务1到并发队列，由于异步提交，将会继续执行asyncOperationsOnConcurrentThread;
 3. 执行完后，并发队列将任务1分配到多个线程执行任务1
 ------------Start------------
 ------------End------------
 任务1 - <NSThread: 0x6000017738c0>{number = 7, name = (null)} - 1
 任务1 - <NSThread: 0x60000178a240>{number = 6, name = (null)} - 0
 任务1 - <NSThread: 0x6000017738c0>{number = 7, name = (null)} - 3
 任务1 - <NSThread: 0x60000178a240>{number = 6, name = (null)} - 5
 任务1 - <NSThread: 0x600001757480>{number = 9, name = (null)} - 6
 任务1 - <NSThread: 0x6000017738c0>{number = 7, name = (null)} - 7
 任务1 - <NSThread: 0x600001757240>{number = 11, name = (null)} - 9
 任务1 - <NSThread: 0x600001704180>{number = 10, name = (null)} - 4
 任务1 - <NSThread: 0x60000174de80>{number = 8, name = (null)} - 2
 任务1 - <NSThread: 0x600001776640>{number = 12, name = (null)} - 8
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
