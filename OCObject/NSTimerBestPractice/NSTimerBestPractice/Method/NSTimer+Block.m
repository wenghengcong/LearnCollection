
//
//  NSTimer+Block.m
//  NSTimerBestPractice
//
//  Created by Hunt on 2019/7/10.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(ho_p_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(ho_p_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)ho_p_ExecuteBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
        {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
        }
}

@end
