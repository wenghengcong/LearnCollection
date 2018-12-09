//
//  main.m
//  Block捕获对象类型
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"

typedef void (^BFBlock)(void);

void testsss()
{
    //
    //        {
    //            MJPerson *person = [[MJPerson alloc] init];
    //            person.age = 10;
    //        }
    //        这里person就会被销毁
    //        NSLog(@"------");
    
    
    //        MJBlock block;
    //
    //        {
    //            MJPerson *person = [[MJPerson alloc] init];
    //            person.age = 10;
    //
    //            MJPerson *weakPerson = person;
    //            block = ^{
    //                NSLog(@"---------%d", weakPerson.age);
    //            };
    //        }
    //        person未被销毁
    //        NSLog(@"------");
    
    
    //        MJBlock block;
    //
    //        {
    //            MJPerson *person = [[MJPerson alloc] init];
    //            person.age = 10;
    //
    //            __weak MJPerson *weakPerson = person;
    //            block = ^{
    //                NSLog(@"---------%d", weakPerson.age);
    //            };
    //        }
    //        person未被销毁
    //        NSLog(@"------");
    
//    MJBlock block;
//
//    {
//        MJPerson *person = [[MJPerson alloc] init];
//        person.age = 10;
//
//        //            __weak MJPerson *weakPerson = person;
//        int age = 10;
//        block = ^{
//            NSLog(@"---------%d", person.age);
//        };
//    }
    
    NSLog(@"------");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /*
         1. 测试Block在栈上访问对象类型
            > 将工程环境设置为MRC环境
        BFBlock block;
        NSLog(@"begin");
        {
            BFPerson *person = [[BFPerson alloc] init];
            person.age = 28;
            block = ^{
                NSLog(@"age %d", person.age);
            };
            NSLog(@"class: %@", [block class]);
            [person release];
        }
        block();
        NSLog(@"end");
         */
        
        /* 2. 测试ARC下，对对象变量的强引用
        BFBlock block;
        NSLog(@"begin");
        {
            BFPerson *person = [[BFPerson alloc] init];
            person.age = 28;
            block = ^{
                NSLog(@"age %d", person.age);
            };
            NSLog(@"class: %@", [block class]);
//            [person release];
        }
        block();
        NSLog(@"end");
         */
        
        /* 3. ARC下对象弱引用
        BFBlock block;
        NSLog(@"begin");
        {
            BFPerson *person = [[BFPerson alloc] init];
            person.age = 28;
            __weak BFPerson *weakSelf = person;
            block = ^{
                NSLog(@"age %d", weakSelf.age);
            };
            NSLog(@"class: %@", [block class]);
            //            [person release];
        }
        block();
        NSLog(@"end");
        */
        
        
        NSLog(@"begin");
        BFPerson *p = [[BFPerson alloc] init];
        __weak BFPerson *weakPerson = p;
        //以强引用person对象为契机，person销毁看person是否还有强引用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"1-------%@", p);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"2-------%@", weakPerson);
            });
        });
        
        NSLog(@"end");
    }
    return 0;
}
