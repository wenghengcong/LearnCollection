//
//  BFPerson.m
//  LLDBLearn
//
//  Created by 翁恒丛 on 2018/11/14.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

- (void)test
{
    NSLog(@"%@ ",NSStringFromSelector(_cmd));
}

- (void)eat:(NSString *)food
{
    NSLog(@"------start-------");
    NSLog(@"eta %@", food);
    NSLog(@"-------end--------");
}

@end
