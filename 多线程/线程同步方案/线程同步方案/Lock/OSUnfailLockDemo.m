//
//  OSUnfailLockDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "OSUnfailLockDemo.h"
#import <os/lock.h>

@interface OSUnfailLockDemo()
@property (assign, nonatomic) os_unfair_lock moneyLock;
@property (assign, nonatomic) os_unfair_lock ticketLock;
@end

@implementation OSUnfailLockDemo

-(void)usage
{
    //初始化
    os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    //尝试加锁
    bool result = os_unfair_lock_trylock(&lock);
    //加锁
    os_unfair_lock_lock(&lock);
    //解锁
    os_unfair_lock_unlock(&lock);
}

- (instancetype)init
{
    if (self = [super init]) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saleTicket
{
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __saveMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

@end
