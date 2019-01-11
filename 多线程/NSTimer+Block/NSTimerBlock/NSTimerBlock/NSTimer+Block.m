//
//  NSTimer+Block.m
//  NSTimerBlock
//
//  Created by WengHengcong on 5/15/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer(JSGBlock)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jsp_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jsp_ExecuteBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)jsp_ExecuteBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end
