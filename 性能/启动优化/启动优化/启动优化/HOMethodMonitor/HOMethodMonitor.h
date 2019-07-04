//
//  HOMethodMonitor.h
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
//#import "HOMethodInvocation.h"

//! Project version number for HOMethodMonitor.
FOUNDATION_EXPORT double HOMethodMonitorVersionNumber;

//! Project version string for HOMethodMonitor.
FOUNDATION_EXPORT const unsigned char HOMethodMonitorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HOMethodMonitor/PublicHeader.h>

#import "HOMethodInvocationEntity.h"

@class HOMethodMonitor;

@protocol HOMethodMonitorDelegate <NSObject>

@optional
- (BOOL)methodMonitor:(HOMethodMonitor *)mehtodMonitor ignoreInvocation:(HOMethodInvocationEntity *)invocation;
- (void)methodMonitor:(HOMethodMonitor *)methodMonitor recordInvocation:(HOMethodInvocationEntity *)invocation;

@end

@interface HOMethodMonitor : NSObject

/// ms
@property (nonatomic, assign) double minTimeCost;

@property (nonatomic, weak) id<HOMethodMonitorDelegate> delegate;

@property (nonatomic, assign) BOOL enbaleDebug;

+ (instancetype)shareInstance;

- (void)start;
- (void)stop;

- (void)addIgnoreQueue:(dispatch_queue_t)queue;
- (void)removeIgnoreQueue:(dispatch_queue_t)queue;

@end
