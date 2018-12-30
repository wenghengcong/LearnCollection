//
//  OSSpinLockDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/28.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo()

@property (assign, nonatomic) OSSpinLock moneyLock;
@property (assign, nonatomic) OSSpinLock ticketLock;

@end

@implementation OSSpinLockDemo

- (void)usage
{
    //初始化
    OSSpinLock lock = OS_SPINLOCK_INIT;
    //尝试加锁（如果已经被其他线程加锁，需要等待，直接返回false；否则加锁成功，返回trure）
    bool result = OSSpinLockTry(&lock);
    //加锁
    OSSpinLockLock(&lock);
    //解锁
    OSSpinLockUnlock(&lock);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.moneyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney
{
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney
{
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTicket
{
    OSSpinLockLock(&_ticketLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_ticketLock);
}


@end
