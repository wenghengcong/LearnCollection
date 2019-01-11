//
//  NSTimer+Block.h
//  NSTimerBlock
//
//  Created by WengHengcong on 5/15/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(JSGBlock)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
