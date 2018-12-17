//
//  NSObject+JSON.h
//  应用
//
//  Created by WengHengcong on 2018/12/17.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JSON)

+ (instancetype)bf_objectWithJson:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
