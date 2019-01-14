//
//  NSTimer+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(JS)

#pragma mark- block

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

#pragma mark- addition

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
