//
//  BFPerson.m
//  Block类型与copy
//
//  Created by WengHengcong on 2018/12/8.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@interface BFPerson()

@end

@implementation BFPerson

- (void)testCopy
{
    void (^globalBlock)(void) = ^{
        NSLog(@"globalBlock");
    };
    
    int age = 10;
    void (^stackBlock)(void) = ^{
        NSLog(@"stackBlock");
        NSLog(@"%d", age);
    };
    
    void (^mallocBlock)(void) = [^{
        NSLog(@"mallocBlock");
        NSLog(@"%d", age);
    } copy];
        
    NSLog(@"class : %@, %@, %@", [globalBlock class], [stackBlock class], [mallocBlock class]);
}


/* ----------------------------------*/
//typedef void (^MRCBlock)(void);

//MRCBlock mrcblock()
//{
//    int age = 10;
//    return ^{
//        NSLog(@"%d", age);
//    };
//}
//
//- (void)testStackBlockInMRC
//{
//    MRCBlock block = mrcblock();
//    block();
//    NSLog(@"%@", [block class]);
//}

/* ----------------------------------*/
- (void)testBlockWithStrong
{
    int age = 28;
    NSLog(@"%@", [^{
        NSLog(@"stack block %d", age);
    } class]);
    
    void (^block)(void) = ^{
        NSLog(@"malloc block %d", age);
    };
    
    NSLog(@"%@", [block class]);
}

@end
