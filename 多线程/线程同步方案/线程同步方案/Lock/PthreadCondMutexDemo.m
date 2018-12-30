//
//  PthreadCondMutexDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "PthreadCondMutexDemo.h"
#import <pthread.h>

@interface PthreadCondMutexDemo()
@property (assign, nonatomic) pthread_mutex_t mutex;
@property (assign, nonatomic) pthread_cond_t cond;
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation PthreadCondMutexDemo

- (void)usage
{
    // 初始化锁
    pthread_mutex_t mutex;
    // NULL代表使用默认属性
    pthread_mutex_init(&mutex, NULL);
    // 初始化条件
    pthread_cond_t cond;
    pthread_cond_init(&cond, NULL);
    // 等待条件（进入休眠，放开mutex锁；被唤醒后，会再次对mutex加锁）
    pthread_cond_wait(&cond, &mutex);
    // 激活一个等待该条件的线程
    pthread_cond_signal(&cond);
    // 激活所有等待该跳进的线程
    pthread_cond_broadcast(&cond);
    // 销毁资源
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
}

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&_mutex, &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        // 初始化条件
        pthread_cond_init(&_cond, NULL);

        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

// 生产者-消费者模式

// 线程1
// 删除数组中的元素
- (void)__remove
{
    pthread_mutex_lock(&_mutex);
    NSLog(@"__remove - begin");
    
    if (self.data.count == 0) {
        // 等待
        pthread_cond_wait(&_cond, &_mutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_mutex);
}

// 线程2
// 往数组中添加元素
- (void)__add
{
    pthread_mutex_lock(&_mutex);
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    // 信号
    pthread_cond_signal(&_cond);
    // 广播
    //    pthread_cond_broadcast(&_cond);
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

@end
