//
//  MobelCom.h
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mobel.h"

@interface MobelCom : NSObject

@property (nonatomic, strong) Mobel *mobel;
@property (nonatomic, copy) NSString *brand;

-(Mobel *)createMobelAtPrice:(NSNumber *)price WithBrand:(NSString *)brand;
-(void)saleMobel:(Mobel *)m;

@end
