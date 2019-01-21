//
//  SingleInstanceThr.h
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleInstanceThr : NSObject
+ (instancetype)sharedThr;
@end

NS_ASSUME_NONNULL_END
