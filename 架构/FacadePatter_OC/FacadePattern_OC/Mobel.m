//
//  Mobel.m
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import "Mobel.h"

@implementation Mobel

- (Mobel *)init{
    self = [super init];
    if (self )
    {
        self.price = @6088;
        self.brand = @"iPhone";
    }
    return self;
}


@end
