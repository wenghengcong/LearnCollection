//
//  main.m
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"
#import "BFPerson1.h"
#import "BFPerson2.h"
#import "BFPerson3.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"------------------------person0----------------------------");
        BFPerson *person0 = [[BFPerson alloc] init];
        person0.rich = YES;
        person0.tall = NO;
        person0.handsome = YES;
        
        NSLog(@"person0 tall:%d rich:%d hansome:%d", person0.tall, person0.rich, person0.handsome);
        
        NSLog(@"------------------------person1----------------------------");
        BFPerson1 *person1 = [[BFPerson1 alloc] init];
        person1.rich = YES;
        person1.tall = YES;
        person1.handsome = NO;
        
        NSLog(@"person1 tall:%d rich:%d hansome:%d", person1.isTall, person1.isRich, person1.isHandsome);
        
        NSLog(@"-------------------------person2---------------------------");
        BFPerson2 *person2 = [[BFPerson2 alloc] init];
        person2.rich = NO;
        person2.tall = YES;
        person2.handsome = YES;
        
        NSLog(@"person2 tall:%d rich:%d hansome:%d", person2.isTall, person2.isRich, person2.isHandsome);
        
        NSLog(@"-------------------------person3---------------------------");
        BFPerson3 *person3 = [[BFPerson3 alloc] init];
        person3.rich = NO;
        person3.tall = NO;
        person3.handsome = YES;
        
        NSLog(@"person3 tall:%d rich:%d hansome:%d", person3.isTall, person3.isRich, person3.isHandsome);
    }
    return 0;
}
