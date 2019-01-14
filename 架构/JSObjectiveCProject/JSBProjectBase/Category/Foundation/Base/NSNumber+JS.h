//
//  NSNumber+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(JS)

/**
 *  比较数值是否相等
 *
 *  @param NSNumber str1
 *  @param NSNumber str2
 *
 *  @return 相等 YES  否则 NO
 */
+ (BOOL)number:(NSNumber *) n1  isEqualToNumber:(NSNumber *) n2;

#pragma mark - 数字格式化

/**
 *  格式化数字
 */
- (NSString*)toDisplayNumberWithDigit:(NSInteger)digit;
/**
 *  格式化成百分比
 */
- (NSString*)toDisplayPercentageWithDigit:(NSInteger)digit;

#pragma mark- 数值处理
/**
 *  四舍五入
 */
- (NSNumber*)doRoundWithDigit:(NSUInteger)digit;
/**
 *  向上取整
 */
- (NSNumber*)doCeilWithDigit:(NSUInteger)digit;
/**
 *  向下取整
 */
- (NSNumber*)doFloorWithDigit:(NSUInteger)digit;

@end
