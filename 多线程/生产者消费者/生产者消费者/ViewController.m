//
//  ViewController.m
//  生产者消费者
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/**
 存在银行的钱
 */
@property (assign, nonatomic) int money;
@property (strong, nonatomic) NSLock *moneyLock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moneyLock = [[NSLock alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self moneyTest];
}


- (void)moneyTest
{
    // 初始有存款200
    self.money = 200;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        // 存了10次，每次30：+300
        for (int i = 0; i < 10; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        // 取了10次，每次10：-100
        for (int i = 0; i < 10; i++) {
            [self __drawMoney];
        }
    });
    
    // 最后应该为200+300-100=400
}

/**
 存钱：每次存30
 */
- (void)__saveMoney
{
    [self.moneyLock lock];
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 30;
    self.money = oldMoney;
    
    NSLog(@"存30，还剩%d元 - %@", self.money, [NSThread currentThread]);
    [self.moneyLock unlock];
}

/**
 取钱：每次取10
 */
- (void)__drawMoney
{
    [self.moneyLock lock];
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 10;
    self.money = oldMoney;
    
    NSLog(@"取10，还剩%d元 - %@", self.money, [NSThread currentThread]);
    [self.moneyLock unlock];
}



@end
