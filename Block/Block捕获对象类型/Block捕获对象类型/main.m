//
//  main.m
//  Block捕获对象类型
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}

typedef void (^BFBlock)(void);

void test()
{
    {
        BFPerson *person = [[BFPerson alloc] init];
        person.age = 28;
    }
    
    BFBlock block;
    NSLog(@"begin");
    {
        BFPerson *person = [[BFPerson alloc] init];
        person.age = 28;
        block = ^{
            NSLog(@"age %d", person.age);
        };
    }
    block();
    NSLog(@"class %@", [block class]);
    NSLog(@"end");
}
