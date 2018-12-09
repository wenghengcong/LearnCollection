//
//  main.m
//  __block
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //查看堆栈的大概地址
        int good = 10;
        BFPerson *person2 = [[BFPerson alloc] init];
        NSLog(@"%p %p", &good, person2);
        
        // 测试block对__block变量地址
        __block int age = 20;
        __block BFPerson *person = [[BFPerson alloc] init];
        
        void(^block)(void) = ^ {
            age = 30;
            person = [[BFPerson alloc] init];
            NSLog(@"malloc address: %p %p", &age, person);
            NSLog(@"malloc age is %d", age);
            NSLog(@"person is %@", person);
        };
        block();
        NSLog(@"stack address: %p %p", &age, person);
        NSLog(@"stack age is %d", age);
        
        /*测试block对__block变量的本质
        __block int age = 20;
        __block BFPerson *person = [[BFPerson alloc] init];
        
        void(^block)(void) = ^ {
            age = 30;
            person = [[BFPerson alloc] init];
            NSLog(@"age is %d", age);
            NSLog(@"person is %@", person);
        };
        block();
        */
        
        /* 测试__block __weak
         只要强引用一旦离开作用域，Block内部为弱引用，之后访问就会为null
         2018-12-09 23:04:31.878787+0800 __block[8202:5689727] begin
         2018-12-09 23:04:31.879022+0800 __block[8202:5689727] BFPerson dealloc
         2018-12-09 23:04:31.879051+0800 __block[8202:5689727] person is (null)
         2018-12-09 23:04:31.879067+0800 __block[8202:5689727] end
         
        void(^block)(void);
        NSLog(@"begin");
        __block int age = 20;
        {
            __block BFPerson *person = [[BFPerson alloc] init];
            __block __weak BFPerson *weakPerson = person;
            block = ^ {
                age = 30;
//                weakPerson = [[BFPerson alloc] init];
                NSLog(@"person is %@", weakPerson);
            };
        }
        block();
        NSLog(@"end");
         */
    }
    return 0;
}
