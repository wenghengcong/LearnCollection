//
//  JSDog.m
//  isEqualDemo
//
//  Created by WengHengcong on 4/12/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "JSDog.h"

@implementation JSDog

- (BOOL)isEqual:(id)object
{
    if ([self class] == [object class]) {
       return [self isEqualToDog:(JSDog *)object];
    }else{
        return [super isEqual:object];
    }
}

- (BOOL)isEqualToDog:(JSDog*)otherDog
{
    if (self == otherDog) {
        return YES;
    }
    
    if ([self class] != [otherDog class]) {
        return NO;
    }
    
    if (_age != otherDog.age) {
        return NO;
    }
    
    if (![_name isEqualToString:otherDog.name]) {
        return NO;
    }
    
    return YES;
}

-(NSUInteger)hash
{
    NSUInteger ageHash = _age;
    NSUInteger nameHash = [_name hash];
    
    return ageHash ^ nameHash;
}

@end
