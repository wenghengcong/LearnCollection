//
//  NSTimerTest.m
//  test
//
//  Created by WengHengcong on 5/15/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "NSTimerTest.h"
#import "NSTimer+Block.h"

@interface NSTimerTest() {
    NSTimer *_pollTimer;
}

@end

@implementation NSTimerTest

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    [_pollTimer invalidate];
    _pollTimer = nil;
}

- (void)startPolling {
    
    __weak typeof(self) weakSelf = self;
    _pollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        NSTimerTest *strongSelf = weakSelf;
        [strongSelf jsp_doPull];
    } repeats:YES];
    
}

- (void)stopPolling {
    
}

- (void)jsp_doPull {
    
}

@end
