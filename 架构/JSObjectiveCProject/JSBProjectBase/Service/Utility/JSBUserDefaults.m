//
//  JSBUserDefaults.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "JSBUserDefaults.h"

@implementation JSBUserDefaults

#pragma mark - 偏好类信息存储

+(NSUserDefaults *)jsbUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
    
}

//保存普通对象
+(void)setString:(NSString *)str key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:str forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}

//读取
+(NSString *)stringForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

//删除
+(void)removeStrForKey:(NSString *)key{
    
    [self setString:nil key:key];
    
}


+ (NSArray *)arrayForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
    
}

+ (NSURL *)URLForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:key];
}

+ (void)setURL:(NSURL *)url key:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setURL:url forKey:key];
    
    //立即同步
    [defaults synchronize];
}

//保存int
+(void)setInteger:(NSInteger)i key:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setInteger:i forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}

//读取
+(NSInteger)integerForKey:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSInteger i=[defaults integerForKey:key];
    
    return i;
}

//保存float
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setFloat:floatValue forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}
//读取
+(CGFloat)floatForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat floatValue=[defaults floatForKey:key];
    
    return floatValue;
}

//保存double
+(void)setDouble:(CGFloat)doubleValue key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setDouble:doubleValue forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}
//读取
+(CGFloat)doubleForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat doubleValue=[defaults doubleForKey:key];
    
    return doubleValue;
}

//保存bool
+(void)setBool:(BOOL)boolValue key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setBool:boolValue forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}
//读取
+(BOOL)boolForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    BOOL boolValue=[defaults boolForKey:key];
    
    return boolValue;
}

//保存对象

+(void)setObject:(id)object key:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

//读取对象

+(id)objectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    return object;
}


@end
