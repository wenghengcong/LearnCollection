//
//  NSTimer+Block.m
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "NSTimer+Block.h"

@interface NSTimer (BlockPrivate)

+ (void)bf_executeBlockFromTimer:(NSTimer *)aTimer;

@end

@implementation NSTimer (Block)

+ (id)bf_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
    NSParameterAssert(block != nil);
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(bf_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+ (id)bf_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))block repeats:(BOOL)inRepeats
{
    NSParameterAssert(block != nil);
    return [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(bf_executeBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+ (void)bf_executeBlockFromTimer:(NSTimer *)aTimer {
    void (^block)(NSTimer *) = [aTimer userInfo];
    if (block) block(aTimer);
}

#pragma mark- addition

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
