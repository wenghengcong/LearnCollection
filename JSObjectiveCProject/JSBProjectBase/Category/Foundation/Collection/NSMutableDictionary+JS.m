//
//  NSMutableDictionary+JS.m
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "NSMutableDictionary+JS.h"

@implementation NSMutableDictionary(JS)

#pragma --mark NSMutableDictionary setter

-(void)setObj:(id)i forKey:(NSString*)key{
    if (i!=nil) {
        self[key] = i;
    }
}
-(void)setString:(NSString*)i forKey:(NSString*)key;
{
    [self setValue:i forKey:key];
}
-(void)setBool:(BOOL)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)setInt:(int)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)setInteger:(NSInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)setCGFloat:(CGFloat)f forKey:(NSString *)key
{
    self[key] = @(f);
}
-(void)setChar:(char)c forKey:(NSString *)key
{
    self[key] = @(c);
}
-(void)setFloat:(float)i forKey:(NSString *)key
{
    self[key] = @(i);
}
-(void)setDouble:(double)i forKey:(NSString*)key{
    self[key] = @(i);
}
-(void)setLongLong:(long long)i forKey:(NSString*)key{
    self[key] = @(i);
}
-(void)setPoint:(CGPoint)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGPoint(o);
}
-(void)setSize:(CGSize)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGSize(o);
}
-(void)setRect:(CGRect)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGRect(o);
}

@end
