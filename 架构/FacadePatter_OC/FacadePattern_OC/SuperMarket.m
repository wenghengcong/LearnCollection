//
//  SuperMarket.m
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import "SuperMarket.h"

@implementation SuperMarket

- (void)saleMobel
{
    MobelCom *mobCom = [[MobelCom alloc]init];
    Mobel *m = [mobCom createMobelAtPrice:@1000 WithBrand:@"KuPai"];
    [mobCom saleMobel:m];
}

- (void)saleClothes
{
    ClothesCom *cloCom = [[ClothesCom alloc]init];
    Clothes *c = [cloCom createClothesAtPrice:@500 WithBrand:@"Ad"];
    [cloCom saleClothes:c];
}

@end
