//
//  Test.m
//  Block捕获对象
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "Test.h"
#import "BFPerson.h"

@implementation Test
//测试如何捕获对象类型
- (void)test
{
    BFPerson *person = [[BFPerson alloc] init];
    person.age = 28;
    void (^block)(void) = ^{
        NSLog(@"age %d", person.age);
    };
    block();
}

@end
