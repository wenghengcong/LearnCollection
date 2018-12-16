//
//  BFGirl.m
//  消息转发
//
//  Created by WengHengcong on 2018/12/16.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFGirl.h"

@implementation BFGirl

- (int)learnedNum
{
    NSLog(@"%s", __func__);
    return 10;
}

- (NSString *)learn:(NSString *)lesson
{
    NSLog(@"%@, %s" , lesson, __func__);
    return @"slwejkljdsklfkldjsfklajskljfelkwjfkljwakelfjkjgkljewoigwejfelwkjfasaoifwjeoiwjeiogjeioajowiejgowjgewiojowwjejlfj";
}

- (NSArray *)learnALot
{
    NSLog(@"%s", __func__);
    return @[@"english", @"math"];
}

@end
