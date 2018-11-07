//
//  JSBHttpResponseResult.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kServerErrorCode_OK,
    kServerErrorCode_NO_MODIFY=304,
    kServerErrorCode_EXISTED=107,
    kServerErrorCode_NotEXISTED = 105,
} kServerErrorCode;


@interface JSBHttpResponseResult : NSObject
{
    /**
     *  服务器返回的结果
     */
    NSDictionary *  _json;
}

/**
 *  使用服务器返回的json数据创建一个 JSBHttpResponseResult 对象
 *
 *  @param responeObject 服务器返回的数据
 *
 *  @return 成功返回 JSBHttpResponseResult 对象，失败返回nil
 */
+ (id) createWithResponeObject:(id) responeObject;

/**
 *  使用json数据创建一个 JSBHttpResponseResult 对象
 *
 *  @param json json数据
 *
 *  @return 成功返回 JSBHttpResponseResult 对象，失败返回nil
 */
- (id) initWithJsonRespone:(NSDictionary *) json;

/**
 *  getter
 *
 */
- (kServerErrorCode)  getErrorCode;
- (NSString *)  getErrorMessge;
- (id) getResponseData;


/**
 * 返回 array 格式的数据
 *
 *  @return 如果服务器返回的数据是 array 格式，则返回 NSArray 对象。否则返回nil
 */
- (NSArray *) tryGetReponseDataInArray;

/**
 *  返回 NSDictonary 格式的数据
 *
 *  @return 如果服务器返回的数据是 NSDictionary 格式，则返回 NSDictonary 对象，否则返回nil
 */
- (NSDictionary *) tryGetReponseDataInDictionary;

/**
 *  获得第一个对象数据
 *
 *  @return 如果第一个数据是NSDictionary （包括在array中的第一个) , 则返回 NSDictionary 对象，否则返回nil
 */
- (NSDictionary *) getResponseFirstObject;

/**
 *  将服务器返回的数据格式化成string
 *
 *  @return 返回格式化后的stringe shig
 */
- (NSString *) description;

@end
