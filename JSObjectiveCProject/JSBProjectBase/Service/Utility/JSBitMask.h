//
//  BitMask.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSBitMask : NSObject

/**
 *  某一位是否设置为1 ( 1到64 之间)
 *
 *  @param value 要设置的数值
 *  @param bit   该数值的比特位
 *
 *  @return 若1，则返回true，否则，返回false
 */
+ (BOOL)isSet:(NSNumber *) value AtBit:(NSNumber *) bit;


/**
 *  设置某位为1
 *
 *  @param NSNumber <#NSNumber description#>
 *
 *  @return <#return value description#>
 */
+ (NSNumber *)set:(NSNumber *) value AtBit:(NSNumber *) bit;


/**
 *  重置某一位为0
 *
 *  @param value <#value description#>
 *  @param bit   <#bit description#>
 *
 *  @return <#return value description#>
 */
+ (NSNumber *)unSet:(NSNumber *) value AtBit:(NSNumber *) bit;

/**
 *   设置一系列位为1
 *
 *  @param value <#value description#>
 *  @param array <#array description#>
 *
 *  @return <#return value description#>
 */
+ (NSNumber *)setFromBitArray:(NSNumber *) value FromArray:(NSArray *) array;

/**
 *   提取出哪些位是1
 *
 *  @param NSArray <#NSArray description#>
 *
 *  @return 返回设置为1的比特位数组
 */
+ (NSArray *)extractToArray:(NSNumber *) value BeginBit:(NSNumber *)begin EndBit:(NSNumber *)end;

@end
