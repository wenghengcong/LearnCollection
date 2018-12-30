//
//  PthreadRecuriseMutexDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "PthreadRecuriseMutexDemo.h"
#import <pthread.h>

@interface PthreadRecuriseMutexDemo()

@property (assign, nonatomic) pthread_mutex_t mutex;

@end

@implementation PthreadRecuriseMutexDemo

- (void)usage
{
    // 初始化锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, &attr);
}

- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 递归锁：允许同一个线程对一把锁进行重复加锁
    
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    if (self = [super init]) {
        [self __initMutex:&_mutex];
    }
    return self;
}

/**
 线程1：otherTest（+-）
 otherTest（+-）
 otherTest（+-）
 
 线程2：otherTest（等待）
 */

- (void)otherTest
{
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"%s", __func__);
    
    static int count = 0;
    if (count < 10) {
        count++;
        [self otherTest2];
    }
    
    pthread_mutex_unlock(&_mutex);
}

- (void)otherTest2
{
    pthread_mutex_lock(&_mutex);

    NSLog(@"%s", __func__);

    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
