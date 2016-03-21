//
//  SetterValueObject.m
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "SetterValueObject.h"

@implementation SetterValueObject

/*
- (void)setName:(NSString *)name {
    
    _name = @"setter name";
}

*/
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"sorry,can't find the key \"%@\"!",key);
}

/**
 *  if set key for nil,call it
 */
- (void)setNilValueForKey:(NSString *)key {
    
    if ([key isEqualToString:@"price"]) {
        price = 0;
    }else{
        [super setNilValueForKey:key];
    }
    
}

@end
