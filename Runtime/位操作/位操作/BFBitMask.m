//
//  BFBitMask.m
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFBitMask.h"

@implementation BFBitMask

+ (BOOL)isSet:(NSNumber *) value AtBit:(NSNumber *) bit{
    if( !value || !bit )
        return NO;
    
    unsigned long long v = [value unsignedLongLongValue];
    unsigned long long b = [bit unsignedLongLongValue];
    if( v & (1<<(b - 1)) )
        return YES;
    
    return NO;
}

+ (NSNumber *)set:(NSNumber *) value AtBit:(NSNumber *) bit{
    if( !value || !bit )
        return nil;
    
    unsigned long long v = [value unsignedLongLongValue];
    unsigned long long b = [bit unsignedLongLongValue];
    unsigned long long nv = v | (1 << (b - 1 ));
    return [NSNumber numberWithLongLong:nv];
}

+ (NSNumber *)unSet:(NSNumber *) value AtBit:(NSNumber *) bit;{
    if( !value || !bit )
        return nil;
    
    unsigned long long v = [value unsignedLongLongValue];
    unsigned long long b = [bit unsignedLongLongValue];
    if( b <= 0 )
        return nil;
    unsigned long long nb = b - 1;
    unsigned long long nv = v;
    nv &= ~(1 << nb);
    return [NSNumber numberWithLongLong:nv];
}

+ (NSNumber *) reset:(NSNumber *) value{
    return @0;
}


+ (NSNumber *)setFromBitArray:(NSNumber *) value FromArray:(NSArray *) array{
    NSNumber * new_value = [NSNumber numberWithUnsignedLongLong:[value unsignedLongLongValue]];
    
    for (id elm in array) {
        if( [elm isKindOfClass:[NSNumber class]] )
        {
            new_value = [BFBitMask set:new_value AtBit:elm];
        }
    }
    
    return new_value;
}

+(NSArray *) extractToArray:(NSNumber *) value BeginBit:(NSNumber *)begin EndBit:(NSNumber *)end{
    if( !value || !begin || !end )
        return nil;
    
    unsigned long long bb = [begin unsignedLongLongValue];
    unsigned long long eb = [end unsignedLongLongValue];
    if( bb > eb ){
        return nil;
    }
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for( unsigned long long i = bb; i <= eb ; i++ )
    {
        if( [BFBitMask isSet:value AtBit:[NSNumber numberWithUnsignedLongLong:i]] )
        {
            [result addObject:[NSNumber numberWithUnsignedLongLong:i]];
        }
    }
    
    return result;
}

@end
