//
//  JSBUserDefaults.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSBUserDefaults : NSObject

+(NSUserDefaults *)jsbUserDefaults;

/**
 *  保存普通字符串
 */
+(void)setString:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+(NSString *)stringForKey:(NSString *)key;

/**
 *  删除
 */
+(void)removeStrForKey:(NSString *)key;


+ (NSArray *)arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName;

+ (NSURL *)URLForKey:(NSString *)key;
+ (void)setURL:(NSURL *)url key:(NSString *)key;

/**
 *  保存int
 */
+(void)setInteger:(NSInteger)i key:(NSString *)key;

/**
 *  读取int
 */
+(NSInteger)integerForKey:(NSString *)key;



/**
 *  保存float
 */
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key;

/**
 *  读取float
 */
+(CGFloat)floatForKey:(NSString *)key;

/**
 *  保存double
 */
+(void)setDouble:(CGFloat)doubleValue key:(NSString *)key;
/**
 *  读取double
 */
+(CGFloat)doubleForKey:(NSString *)key;
/**
 *  保存bool
 */
+(void)setBool:(BOOL)boolValue key:(NSString *)key;

/**
 *  读取bool
 */
+(BOOL)boolForKey:(NSString *)key;
/**
 *  保存对象
 */
+(void)setObject:(id)object key:(NSString *)key;
/**
 *  读取对象
 */
+(id)objectForKey:(NSString *)key;


@end
