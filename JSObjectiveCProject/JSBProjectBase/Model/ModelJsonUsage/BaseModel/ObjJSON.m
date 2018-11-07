//
//  ObjJSON.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjJSON.h"

@implementation ObjJSON

- (NSNumber *) readNumberField:(NSDictionary *) data fieldName:(NSString *) fieldName{
    if( ![data isKindOfClass:[NSDictionary class]] )
        return nil;
    
    id field = [data objectForKey:fieldName];
    if( field == [NSNull null] )
        return nil;
    if( [field isKindOfClass:[NSNumber class] ] )
    {
        return field;
    }
    else if( [field isKindOfClass:[NSString class]] )
    {
        NSNumberFormatter * num_format = [[NSNumberFormatter alloc] init];
        NSNumber * ret = [num_format numberFromString:field];
        
        return ret;
    }
    return nil;
}

-(NSString *)readStringField:(NSDictionary *) data fieldName:(NSString *) fieldName {

    if( ![data isKindOfClass:[NSDictionary class]] )
        return nil;
    
    id field = [data objectForKey:fieldName];
    if( field == [NSNull null] ){
        return @"";
    }else if( [field isKindOfClass:[NSNumber class] ] )
    {
        NSNumberFormatter * num_format = [[NSNumberFormatter alloc] init];
        NSString * ret = [num_format stringFromNumber:field];
        
        return ret;
    }else if([field isKindOfClass:[NSString class]])
    {
        return field;
    }
    
    return @"";
}

- (BOOL)readBoolField:(NSDictionary *) data fieldName:(NSString *) fieldName {
    
    if( ![data isKindOfClass:[NSDictionary class]] ){
        return NO;
    }
    
    id field = [data objectForKey:fieldName];
    if( field == [NSNull null] ){
        return NO;
    }else if( [field isKindOfClass:[NSString class]] )
    {
        NSNumberFormatter * num_format = [[NSNumberFormatter alloc] init];
        NSNumber * temp = [num_format numberFromString:field];
        BOOL outResult =  [temp boolValue];
        return outResult;
    }else  if( [field isKindOfClass:[NSNumber class] ] )
    {
        NSNumber * temp = (NSNumber *)field;
        BOOL outResult = [temp boolValue];
        return outResult;
    }
    return NO;
    
}
- (NSDictionary *)readDictField:(NSDictionary *) data fieldName:(NSString *)fieldNname{
    if( ![data isKindOfClass:[NSDictionary class]] )
        return nil;
    
    id field = [data objectForKey:fieldNname];
    if( field == [NSNull null] ){
        return nil;
    }else if( [field isKindOfClass:[NSDictionary class]] )
    {
        return field;
    }
    
    return nil;
}

- (NSArray *)readArrayField:(NSDictionary *) data fieldName:(NSString *)fieldName {
    if( ![data isKindOfClass:[NSDictionary class]] ){
        return nil;
    }
    id field = [data objectForKey:fieldName];
    if( field == [NSNull null] ){
        return nil;
    }else if( [field isKindOfClass:[NSArray class]] )
    {
        return field;
    }
    
    return nil;
}

@end
