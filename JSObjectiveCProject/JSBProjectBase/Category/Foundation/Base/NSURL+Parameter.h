//
//  NSURL+Parameter.h
//  CategoryCollection
//
//  Created by whc on 15/7/28.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(Parameter)
/**
 *  获取URL中的所有参数
 */
- (NSDictionary *)parameters;
/**
 *  获取URL中的某个参数
 */
- (NSString *)valueForParameter:(NSString *)parameterKey;

@end
