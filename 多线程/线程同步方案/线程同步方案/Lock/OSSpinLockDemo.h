//
//  OSSpinLockDemo.h
//  线程同步方案
//
//  Created by WengHengcong on 2018/12/28.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDemo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 High-level lock
 高层级锁，自旋锁，会一直占用着CPU资源，即“忙等”
 These interfaces should no longer be used, particularily in situations where
 threads of differing priorities may contend on the same spinlock.
 */
@interface OSSpinLockDemo : BaseDemo

@end

NS_ASSUME_NONNULL_END
