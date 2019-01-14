//
//  ClothesCom.m
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import "ClothesCom.h"

@implementation ClothesCom



-(Clothes *)createClothesAtPrice:(NSNumber *)price WithBrand:(NSString *)brand
{
    Clothes *c = [[Clothes alloc]init];
    c.price = price;
    c.brand = brand;
    return c;
}

-(void)saleClothes:(Clothes *)c
{
    NSLog(@"sale clothes at %@",c.price);
}

@end
