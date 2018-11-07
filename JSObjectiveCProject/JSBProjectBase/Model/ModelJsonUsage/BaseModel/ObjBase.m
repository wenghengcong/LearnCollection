//
//  ObjBase.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjBase.h"



@implementation ObjBase

- (NSString *)getGUIDWithString
{
    if( [self.guid isKindOfClass:[NSNumber class]] )
    {
        return [self.guid stringValue];
    }else if( [self.guid isKindOfClass:[NSString class]] )
    {
        return self.guid;
    }
    return nil;
}

+ (NSComparisonResult) comparisonWithGUID:(ObjBase *) left WithRight:(ObjBase *) right {
    
    if( ([left.guid isKindOfClass:[NSNumber class]] && [right.guid isKindOfClass:[NSNumber class]]) ||
       ([left.guid isKindOfClass:[NSString class]] && [right.guid isKindOfClass:[NSString class]]) )
    {
        return [left.guid compare:right.guid];
    }else{
        
        NSString * left_string_guid = [left getGUIDWithString];
        NSString * right_string_guid = [right getGUIDWithString];
        if( left_string_guid && right_string_guid )
        {
            return [left_string_guid compare:right_string_guid];
        }
    }
    return NSOrderedAscending;
}

-(id) initWithDirectory:(NSDictionary *) data
{
    self = [super init];
    if( self )
    {
        NSNumber * number_guid  = [self readNumberField:data fieldName:@"id"];
        if( number_guid == nil )
        {
            NSString * string_guid = [self readStringField:data fieldName:@"id"];
            if( string_guid )
            {
                self.guid = string_guid;
            }
        }else
        {
            self.guid = number_guid;
        }
        
        self.class_type = [self readStringField:data fieldName:@"class_type"];
        self.created_at = [self readStringField:data fieldName:@"created_at"];
        self.updated_at = [self readStringField:data fieldName:@"updated_at"];        
    }
    
    return self;
}

#pragma mark- NSCopying
/**
 *  decode
 */
-(id) initWithCoder:( NSCoder *)coder
{
    if( self = [super init] )
    {
        self.guid = [coder decodeObjectForKey:@"id"];
        self.class_type = [coder decodeObjectForKey:@"class_type"];
        self.created_at = [coder decodeObjectForKey:@"created_at"];
        self.updated_at = [coder decodeObjectForKey:@"updated_at"];
    }
    
    return self;
}
/**
 *  encode
 */
-(void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: self.guid forKey:@"id"];
    [coder encodeObject: self.class_type forKey:@"class_type"];
    [coder encodeObject: self.created_at  forKey:@"created_at"];
    [coder encodeObject: self.updated_at  forKey:@"updated_at"];
}
@end

/**
 *  ObjBase排序实现
 */
@implementation ObjBase (numericComparison)

/*
 按id从大到小排序(即先看到最新的内容)
 */
- (NSComparisonResult) compareNumericallyDESC:(ObjBase *) other
{
    if( self.guid == nil || other.guid == nil )
        return NSOrderedAscending;
    
    
    return [ObjBase comparisonWithGUID:other WithRight:self];
}

//
- (NSComparisonResult) compareNumericallyASC:(ObjBase *) other
{
    if( self.guid == nil || other.guid == nil )
        return NSOrderedAscending;
    
    return [ObjBase comparisonWithGUID:self WithRight:other];
}

@end
