//
//  CaptureGlobalBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureGlobalBlock.h"

@implementation CaptureGlobalBlock

int height = 170;

- (void)test
{
    NSLog(@"captrue global variable in block");

    void (^personInfoBlock)(void) = ^() {
        NSLog(@"height is %d", height);
    };
    
    height = 180;
    personInfoBlock();
}

@end
