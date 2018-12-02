//
//  BFPerson+BFBoy.m
//  AssociatedObjectDemo
//
//  Created by WengHengcong on 2018/12/2.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson+BFBoy.h"

@implementation BFPerson (BFBoy)

NSMutableDictionary *ages_;

+ (void)load
{
    ages_ = [[NSMutableDictionary alloc] init];
}

- (void)setAge:(NSInteger)age
{
    NSString *key = [NSString stringWithFormat:@"%p", self];
    ages_[key] = @(age);
}

- (NSInteger)age
{
    NSString *key = [NSString stringWithFormat:@"%p", self];
    return [ages_[key] integerValue];
}

@end
