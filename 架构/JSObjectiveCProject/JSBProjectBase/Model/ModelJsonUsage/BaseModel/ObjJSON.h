//
//  ObjJSON.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  解析json格式的对象
 */
@interface ObjJSON : NSObject


/**
 *  解析一个number 属性
 *
 *  @param data       数据源
 *  @param fieldName 属性名
 *
 *  @return 返回解析的number对象，失败返回nil
 */
- (NSNumber *) readNumberField:(NSDictionary *) data fieldName:(NSString *) fieldName;

/**
 *  解析一个字符串属性
 *
 *  @param data       数据源
 *  @param fieldName 属性名
 *
 *  @return 返回解析的string对象，失败返回nil
 */
-(NSString *)readStringField:(NSDictionary *) data fieldName:(NSString *) fieldName;

/**
 *  解析一个bool属性
 *
 *  @param data       数据源
 *  @param fieldName 属性名
 *
 *  @return 解析成功返回true
 */
- (BOOL)readBoolField:(NSDictionary *) data fieldName:(NSString *) fieldName;

/**
 *  解析一个 NSDictionary 对象
 *
 *  @param data       数据源
 *  @param fieldName 属性名
 *
 *  @return 返回解析的 NSDictionary 对象，失败返回nil
 */
- (NSDictionary *)readDictField:(NSDictionary *) data fieldName:(NSString *)fieldNname;

/**
 *  解析一个 NSArray 对象
 *  @param data       数据源
 *  @param fieldName 属性名
 *
 *  @return 返回解析的 NSArray 对象,失败返回nil
 */
- (NSArray *)readArrayField:(NSDictionary *) data fieldName:(NSString *)fieldName;




@end
