//
//  ViewController.m
//  LockLearn
//
//  Created by 翁恒丛 on 2018/8/30.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import <libkern/OSSpinLockDeprecated.h>
#import <os/lock.h>

#define repeateLockCount (1000 * 1000 * 10)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testAllLockType];
}

- (void)testAllLockType
{
    [self testSynchronized];
    [self testMutex];
    [self testMutexRecursive];
    [self testNSLock];
    [self testCondition];
    [self testConditionLock];
    [self testRecursiveLock];
    [self testSemaphore];
    [self testOSSpinLock];
    [self testOSUnfairLock];
    [self testPthreadReadLock];
    [self testPthreadWriteLock];
}

- (void)testSynchronized
{
    //@synchronized
    NSObject *lock = [[NSObject alloc]init];;
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        @synchronized(lock){
        }
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("@synchronized              : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testNSLock
{
    NSLock *lock = [[NSLock alloc]init];
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        [lock lock];
        [lock unlock];
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("NSLock                     : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testCondition
{
    NSCondition *condition = [[NSCondition alloc]init];
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        [condition lock];
        [condition unlock];
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("NSCondition                : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testConditionLock
{
    NSConditionLock *conditionLock = [[NSConditionLock alloc]init];
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        [conditionLock lock];
        [conditionLock unlock];
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("NSConditionLock            : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testRecursiveLock
{
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc]init];
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        [recursiveLock lock];
        [recursiveLock unlock];
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock            : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testMutex
{
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("pthread_mutex              : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testMutexRecursive
{
    pthread_mutex_t mutex;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);
    pthread_mutexattr_destroy(&attr);
    
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("pthread_mutex(recursive)   : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("dispatch_semaphore         : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testOSSpinLock
{
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        OSSpinLockLock(&spinlock);
        OSSpinLockUnlock(&spinlock);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("OSSpinLock                 : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testOSUnfairLock
{
    os_unfair_lock_t unfairLock;
    unfairLock = &(OS_UNFAIR_LOCK_INIT);
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        os_unfair_lock_lock(unfairLock);
        os_unfair_lock_unlock(unfairLock);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("os unfair lock             : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testPthreadReadLock
{

    pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        pthread_rwlock_rdlock(&rwlock);
        pthread_rwlock_unlock(&rwlock);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("pthread read lock             : %8.2f ms\n", (end-begin) * 1000);
}

- (void)testPthreadWriteLock
{
    pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    for(int i = 0; i < repeateLockCount; i++){
        pthread_rwlock_wrlock(&rwlock);
        pthread_rwlock_unlock(&rwlock);
    }
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    printf("pthread write lock             : %8.2f ms\n", (end-begin) * 1000);
}

@end
