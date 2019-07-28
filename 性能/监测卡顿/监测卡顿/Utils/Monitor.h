//
//  Moniter.h
//  监测卡顿
//
//  Created by Hunt on 2019/7/26.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Monitor : NSObject

- (instancetype)shared;


/**
 开始监控
 */
- (void)beginMonitor;


/**
 停止监控
 */
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
