//
//  ObjBase.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjJSON.h"

/***  数据模块的基础类 */
@interface ObjBase : ObjJSON


/***  对象的唯一id*/
@property (nonatomic,retain)id    guid;

/***  对象类型*/
@property (nonatomic,retain)NSString        *class_type;

/***  创建时间*/
@property (nonatomic,retain)NSString        *created_at;

/***  更新时间*/
@property (nonatomic,retain)NSString        *updated_at;


- (id) initWithDirectory:(NSDictionary *) data;

+ (NSComparisonResult) comparisonWithGUID:(ObjBase *) left WithRight:(ObjBase *) right;
- (NSString *)   getGUIDWithString;

@end

/***  ObjBase排序实现*/
@interface ObjBase (numericComparison)

/*按id降序排序(即先看到最新的内容)*/
- (NSComparisonResult) compareNumericallyDESC:(ObjBase *) other;

/***  按id升序，即最旧的内容在先*/
- (NSComparisonResult) compareNumericallyASC:(ObjBase *) other;


@end
