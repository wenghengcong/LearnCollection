//
//  ViewController.m
//  读写安全
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>


@interface ViewController ()
@property (strong, nonatomic) dispatch_queue_t queue;
@property (assign, nonatomic) pthread_rwlock_t lock;
@end

@implementation ViewController

- (void)usage
{
    // 初始化锁
    pthread_rwlock_t lock;
    pthread_rwlock_init(&lock, NULL);
    // 读-尝试加锁
    pthread_rwlock_tryrdlock(&lock);
    // 读-加锁
    pthread_rwlock_rdlock(&lock);
    // 写-尝试加锁
    pthread_rwlock_trywrlock(&lock);
    // 写-加锁
    pthread_rwlock_wrlock(&lock);
    // 解锁
    pthread_rwlock_unlock(&lock);
    // 销毁
    pthread_rwlock_destroy(&lock);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //    queue.maxConcurrentOperationCount = 5;
    
    //    dispatch_semaphore_create(5);
    
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
    }
}


- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write
{
    sleep(1);
    NSLog(@"write");
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
//
//    for (int i = 0; i < 10; i++) {
//        [self read];
//        [self read];
//        [self read];
//        [self write];
//    }
//}
//
//
//- (void)read {
//    dispatch_async(self.queue, ^{
//        sleep(1);
//        NSLog(@"read");
//    });
//}
//
//- (void)write
//{
//    dispatch_barrier_async(self.queue, ^{
//        sleep(1);
//        NSLog(@"write");
//    });
//}
//
//

- (void)readWriteLock {
    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self readByLock];
        });
        dispatch_async(queue, ^{
            [self writeByLock];
        });
    }
}

- (void)readByLock {
    pthread_rwlock_rdlock(&_lock);
    sleep(1);
    NSLog(@"read");
    pthread_rwlock_unlock(&_lock);
}

- (void)writeByLock
{
    pthread_rwlock_wrlock(&_lock);
    sleep(1);
    NSLog(@"write");
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
}


@end
