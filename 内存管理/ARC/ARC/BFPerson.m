//
//  BFPerson.m
//  ARC
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPerson.h"


@implementation BFPerson

- (void)eat
{
    NSLog(@"%s", __func__);
}

-(void)dealloc
{
    NSLog(@"%s", __func__);
    self.name = nil;
}

@end
