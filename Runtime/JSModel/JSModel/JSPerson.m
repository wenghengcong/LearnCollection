//
//  JSPerson.m
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import "JSPerson.h"

@implementation JSPerson

+ (NSDictionary *)objectInArray
{
    return @{
             @"books":@"JSBook"
             };
}

- (NSString *)description
{
    NSString *perDes  = [NSString stringWithFormat:@"I'm a boy,my name is %@ age:%ld height:%@ sex:%@ .",_name,(long)_age,_height,(_sex ? @"male" :@"female" )];
    return perDes;
}

@end
