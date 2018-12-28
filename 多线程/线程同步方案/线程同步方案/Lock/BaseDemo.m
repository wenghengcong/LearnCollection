//
//  BaseDemo.m
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/28.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BaseDemo.h"

@interface BaseDemo()
@property (assign, nonatomic) int money;
@property (assign, nonatomic) int ticketsCount;
@end

@implementation BaseDemo

- (void)otherTest
{
    
}

#pragma mark - 存钱/取钱

/**
 存钱、取钱演示
 */
- (void)moneyTest
{
    self.money = 200;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __drawMoney];
        }
    });
}

/**
 存钱
 */
- (void)__saveMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 30;
    self.money = oldMoney;
    
    NSLog(@"存30，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

/**
 取钱
 */
- (void)__drawMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 10;
    self.money = oldMoney;
    
    NSLog(@"取10，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

#pragma mark - 售票

/**
 卖票演示
 */
- (void)ticketTest
{
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //    for (int i = 0; i < 10; i++) {
    //        [[[NSThread alloc] initWithTarget:self selector:@selector(__saleTicket) object:nil] start];
    //    }
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
}

/**
 卖1张票
 */
- (void)__saleTicket
{
    int oldTicketsCount = self.ticketsCount;
    sleep(.2);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
}

@end
