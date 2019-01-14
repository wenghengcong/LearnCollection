//
//  ClothesCom.h
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clothes.h"
@interface ClothesCom : NSObject

@property (nonatomic, strong) Clothes *clothes;
@property (nonatomic, copy) NSString *brand;

-(Clothes *)createClothesAtPrice:(NSNumber *)price WithBrand:(NSString *)brand;
-(void)saleClothes:(Clothes *)c;

@end
