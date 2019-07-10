//
//  NSTimer+Block.h
//  NSTimerBestPractice
//
//  Created by Hunt on 2019/7/10.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                                        block:(void (^)(void))inBlock
                                      repeats:(BOOL)inRepeats;

+(instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
                               block:(void (^)(void))inBlock
                             repeats:(BOOL)inRepeats;

@end

NS_ASSUME_NONNULL_END
