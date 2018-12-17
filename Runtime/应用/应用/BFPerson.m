//
//  BFPerson.m
//  应用
//
//  Created by WengHengcong on 2018/12/17.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

- (void)eat
{
    NSLog(@"%s", __func__);
}

- (void)run
{
    NSLog(@"%s", __func__);
}

- (void)learn
{
    NSLog(@"%s", __func__);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"id %d, name %@, age %d", self.ID, self.name, self.age];
}

@end
