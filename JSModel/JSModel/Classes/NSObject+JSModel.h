//
//  NSObject+JSModel.h
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

//http://www.jianshu.com/p/d2ecef03f19e


#import <Foundation/Foundation.h>


@protocol JSModel <NSObject>

@optional

+ (NSDictionary *)objectInArray;

@end

@interface NSObject (JSModel)<JSModel>

+ (NSArray *)properties;

+ (instancetype)modelWithDic:(NSDictionary *)dic;


@end
