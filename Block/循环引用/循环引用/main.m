//
//  main.m
//  循环引用
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"

/*

 
 //解决循环引用1---MRC方案一
 //    __block typeof(self) weakSelf = self;
 //    self.block = ^{
 //        NSLog(@"age is %d", weakSelf.age);
 //    };
 
 //解决循环引用1---MRC方案二
 __unsafe_unretained typeof(self) weakSelf = self;
 self.block = ^{
 NSLog(@"age is %d", weakSelf.age);
 };
 */

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"main begin");
        
        // __weak：不会产生强引用，指向的对象销毁时，会自动让指针置为nil
        // __unsafe_unretained：不会产生强引用，不安全，指向的对象销毁时，指针存储的地址值不变
        
        /*************   ARC环境下   ***************/
        //循环引用情况1
//        person->Block->person
//        BFPerson *person = [[BFPerson alloc] init];
//        person.block = ^{
//            NSLog(@"age is %d", person.age);
//        };
        
        //解决循环引用1---ARC方案一
//        BFPerson *person = [[BFPerson alloc] init];
//        __weak typeof(person) weakSelf = person;
//        person.block = ^{
//            NSLog(@"age is %d", weakSelf.age);
//        };
        
        //解决循环引用1---ARC方案一衍生优化
//        BFPerson *person = [[BFPerson alloc] init];
//        __weak typeof(person) weakSelf = person;
//        person.block = ^{
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            NSLog(@"age is %d", strongSelf.age);
//        };
        
        //解决循环引用1---ARC方案二
//        BFPerson *person = [[BFPerson alloc] init];
//        __unsafe_unretained typeof(person) weakSelf = person;
//        person.block = ^{
//            NSLog(@"age is %d", weakSelf.age);
//        };
        
        
        //循环引用情况2
        //person -> Block -> __block对象 -> person
//        __block BFPerson *person = [[BFPerson alloc] init];
//        person.block = ^{
//            NSLog(@"age is %d", person.age);
//        };

        //循环引用情况2--ARC方案一
        __block BFPerson *person = [[BFPerson alloc] init];
        person.block = ^{
            NSLog(@"age is %d", person.age);
            person = nil;
        };
        person.block();       //必须执行block，否则person不能为nil
        
        
        /*************  MRC环境下  ***************/
        
        //解决循环引用1---ARC方案一
//        BFPerson *person = [[BFPerson alloc] init];
//        __unsafe_unretained typeof(person) weakSelf = person;
//        person.block = ^{
//            NSLog(@"age is %d", weakSelf.age);
//        };
//        [person release];
        
        
        //解决循环引用1---ARC方案二
        BFPerson *person = [[BFPerson alloc] init];
        __block typeof(person) weakSelf = person;
        person.block = ^{
            NSLog(@"age is %d", weakSelf.age);
        };
        [person release];
        
    }
    NSLog(@"main end");
    return 0;
}
