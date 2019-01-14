//
//  ObjList.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjBase.h"

/**
 *  对象列表
 */
@interface ObjList : NSObject


/**
 *  根据一个guid查找对象
 *
 *  @param guid 要查找的对象id
 *
 *  @return 返回找到的对象,不存在返回nil
 */
- (ObjBase *)findObjBase:(NSNumber *) guid;


/**
 *  添加一个对象
 *
 *  @param elm 要添加的对象
 
 *  @return 成功返回true
 */
- (BOOL) addObjBase:(ObjBase *)elm;

/**
 *  删除一个对象
 *
 *  @param guid 要删除的对象id
 */
- (void) removeObjBase:(NSNumber*) guid;

/**
 *  根据对象id排序获得指定索引位置的一个对象
 *
 *  @param idx     索引位置，0-n
 *  @param is_desc 是否降序
 *
 *  @return 返回找到的对象id
 */
- (ObjBase *) getObjectAtIndex:(NSInteger) idx WithIsDESC:(BOOL) is_desc;

/**
 *  获得列表中id最大的一个对象
 *
 *  @return 返回guid最大的对象，列表空返回nil
 */
- (ObjBase *) getMaxIDObjBase;

/**
 *  获得列表中id最小的一个对象
 *
 *  @return 返回guid最小的对象，列表空返回nil
 */
- (ObjBase *) getMinIDObjBase;

/**
 *  查找对象所在的索引位置
 *
 *  @param obj 要找的对象
 *
 *  @return 对象存在列表中返回所在位置 >= 0 , 不存在返回-1
 */
- (NSInteger)indexOfObjBase:(ObjBase *) obj;

/**
 *  清空列表
 */
- (void)removeAllObjBase;

/**
 *  获得列表个数
 *
 *  @return 返回列表个数
 */
- (NSUInteger) countOfList;

/**
 *  根据id大小排序后限制列表大小
 *
 *  @param limit_size 要限制的大小
 */
- (void) limitSizeByGUID:(NSUInteger) limit_size;

/**
 *  将另一个列表和自己合并
 *
 *  @param otherList 需要合并的列表
 */
- (void)appendFromObjList:(ObjList *)otherList;



@end
