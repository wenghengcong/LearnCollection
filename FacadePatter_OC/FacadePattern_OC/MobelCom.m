//
//  MobelCom.m
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import "MobelCom.h"

@implementation MobelCom

- (MobelCom *)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (Mobel *)createMobelAtPrice:(NSNumber *)price WithBrand:(NSString *)brand
{
    Mobel *m = [[Mobel alloc]init];
    m.brand = brand;
    m.price = price;
    return m;
}

- (void)saleMobel:(Mobel *)m{
    NSLog(@"sale one Lenovo mobel at %@",m.price);
}

@end
