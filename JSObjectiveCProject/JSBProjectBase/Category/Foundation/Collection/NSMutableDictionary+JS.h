//
//  NSMutableDictionary+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface NSMutableDictionary(JS)

#pragma --mark NSMutableDictionary setter

-(void)setObj:(id)i forKey:(NSString*)key;

-(void)setString:(NSString*)i forKey:(NSString*)key;

-(void)setBool:(BOOL)i forKey:(NSString*)key;

-(void)setInt:(int)i forKey:(NSString*)key;

-(void)setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)setChar:(char)c forKey:(NSString*)key;

-(void)setFloat:(float)i forKey:(NSString*)key;

-(void)setDouble:(double)i forKey:(NSString*)key;

-(void)setLongLong:(long long)i forKey:(NSString*)key;

-(void)setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)setSize:(CGSize)o forKey:(NSString*)key;

-(void)setRect:(CGRect)o forKey:(NSString*)key;


@end
