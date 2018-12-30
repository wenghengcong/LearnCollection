//
//  PthreadMutexDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "PthreadMutexDemo.h"
#import <pthread.h>

@interface PthreadMutexDemo()
@property (assign, nonatomic) pthread_mutex_t ticketMutex;
@property (assign, nonatomic) pthread_mutex_t moneyMutex;
@end

@implementation PthreadMutexDemo

- (void)usage
{
    // 静态初始化
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    
    // 初始化锁属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁
    pthread_mutex_init(&mutex, &attr);
    
    // 尝试加锁
    pthread_mutex_trylock(&mutex);
    // 加锁
    pthread_mutex_lock(&mutex);
    // 解锁
    pthread_mutex_unlock(&mutex);
    // 销毁
    pthread_mutexattr_destroy(&attr);
    pthread_mutex_destroy(&mutex);
}

- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 初始化锁
    pthread_mutex_init(mutex, NULL);
}

- (instancetype)init
{
    if (self = [super init]) {
        [self __initMutex:&_ticketMutex];
        [self __initMutex:&_moneyMutex];
    }
    return self;
}

// 死锁：永远拿不到锁
- (void)__saleTicket
{
    pthread_mutex_lock(&_ticketMutex);
    
    [super __saleTicket];
    
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)__saveMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __saveMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __drawMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_ticketMutex);
}

@end
