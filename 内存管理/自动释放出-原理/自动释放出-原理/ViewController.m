//
//  ViewController.m
//  自动释放出-原理
//
//  Created by WengHengcong on 2019/1/5.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
#import <Foundation/Foundation.h>

extern void _objc_autoreleasePoolPrint(void);

@interface ViewController ()

@end

@implementation ViewController

/*
 方法里有局部对象， 出了方法后会立即释放吗
 1. 如果ARC对应生成的是autorelease，那么就不会
 2. 如果ARC对应生成的是release，就会。实际情况验证是这种情况。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // 这个Person什么时候调用release，是由RunLoop来控制的
    // 它可能是在某次RunLoop循环中，RunLoop休眠之前调用了release
    //    BFPerson *person = [[[BFPerson alloc] init] autorelease];
    // person对象不是有main函数中的autorelease pool管理的
    // 在viewWillAppear里调用
    BFPerson *person = [[[BFPerson alloc] init] autorelease];
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
}

- (void)test
{
    @autoreleasepool { //  r1 = push()
        
        BFPerson *p1 = [[[BFPerson alloc] init] autorelease];
        BFPerson *p2 = [[[BFPerson alloc] init] autorelease];
        
        @autoreleasepool { // r2 = push()
            for (int i = 0; i < 600; i++) {
                BFPerson *p3 = [[[BFPerson alloc] init] autorelease];
            }
            
            @autoreleasepool { // r3 = push()
                BFPerson *p4 = [[[BFPerson alloc] init] autorelease];

                //打印出来，有code和hot（当前正在使用的page）
                _objc_autoreleasePoolPrint();
            } // pop(r3)
            
        } // pop(r2)
        
        
    } // pop(r1)
}

- (void)test2
{
//    atautoreleasepoolobj = objc_autoreleasePoolPush();
    
    BFPerson *person = [[[BFPerson alloc] init] autorelease];
    
//    objc_autoreleasePoolPop(atautoreleasepoolobj);
    /*
      //@autoreleasepool
     {
        __AtAutoreleasePool __autoreleasepool;
         for (int i = 0; i < 1000; i++) {
             BFPerson *person = ((BFPerson *(*)(id, SEL))(void *)objc_msgSend)((id)((BFPerson *(*)(id, SEL))(void *)objc_msgSend)((id)((BFPerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("BFPerson"), sel_registerName("alloc")), sel_registerName("init")), sel_registerName("autorelease"));
         }
     }
     
     相当于：
     atautoreleasepoolobj = objc_autoreleasePoolPush();
     
     BFPerson *person = [[[BFPerson alloc] init] autorelease];

     objc_autoreleasePoolPop(atautoreleasepoolobj);
     
     */
    //        atautoreleasepoolobj = objc_autoreleasePoolPush();
    // atautoreleasepoolobj = 0x1038
    @autoreleasepool {
        for (int i = 0; i < 1000; i++) {
            BFPerson *person = [[[BFPerson alloc] init] autorelease];
        } // 8000个字节
    }
    //        objc_autoreleasePoolPop(0x1038);
    
    @autoreleasepool {
        BFPerson *person = [[[BFPerson alloc] init] autorelease];
    }
}


/*
 
 struct __AtAutoreleasePool {
 __AtAutoreleasePool() { // 构造函数，在创建结构体的时候调用
    atautoreleasepoolobj = objc_autoreleasePoolPush();
 }
 
 ~__AtAutoreleasePool() { // 析构函数，在结构体销毁的时候调用
    objc_autoreleasePoolPop(atautoreleasepoolobj);
 }
 
 void * atautoreleasepoolobj;
 };

 */

/*
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0),  1
    kCFRunLoopBeforeTimers = (1UL << 1), 2
    kCFRunLoopBeforeSources = (1UL << 2), 4
    kCFRunLoopBeforeWaiting = (1UL << 5), 32
    kCFRunLoopAfterWaiting = (1UL << 6), 64
    kCFRunLoopExit = (1UL << 7), 128
    kCFRunLoopAllActivities = 0x0FFFFFFFU
 };
 */

/*
 kCFRunLoopEntry  push
 
 <CFRunLoopObserver 0x60000013f220 [0x1031c8c80]>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x103376df2), context = <CFArray 0x60000025aa00 [0x1031c8c80]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7fd0bf802048>\n)}}
 
 
 kCFRunLoopBeforeWaiting | kCFRunLoopExit
 kCFRunLoopBeforeWaiting pop、push
 kCFRunLoopExit pop
 
 <CFRunLoopObserver 0x60000013f0e0 [0x1031c8c80]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x103376df2), context = <CFArray 0x60000025aa00 [0x1031c8c80]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7fd0bf802048>\n)}}
 */


@end
