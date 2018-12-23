//
//  BFPermenantThread.h
//  线程保活—封装
//
//  Created by WengHengcong on 2018/12/24.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BFPermenantThreadTask)(void);

@interface BFPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(BFPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;


@end

NS_ASSUME_NONNULL_END
