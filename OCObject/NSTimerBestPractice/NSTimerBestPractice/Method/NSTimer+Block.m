
//
//  NSTimer+Block.m
//  NSTimerBestPractice
//
//  Created by Hunt on 2019/7/10.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats
{
    void (^block)(void) = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(ho_p_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats
{
    void (^block)(void) = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(ho_p_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)ho_p_ExecuteBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
        {
        void (^block)(void) = (void (^)(void))[inTimer userInfo];
        block();
        }
}

@end
