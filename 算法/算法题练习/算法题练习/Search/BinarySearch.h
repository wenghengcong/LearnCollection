//
//  BinarySearch.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/24.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinarySearch : NSObject

+ (int)binarySearchByKey:(int)key array:(int[])array length:(int)length;
+ (int)binarySearchByKey:(int)key array:(int [])array lower:(int)lo high:(int)hi;

@end

NS_ASSUME_NONNULL_END
