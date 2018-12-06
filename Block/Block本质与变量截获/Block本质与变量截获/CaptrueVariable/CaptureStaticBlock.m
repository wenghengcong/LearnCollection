//
//  CaptureStaticBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureStaticBlock.h"

@implementation CaptureStaticBlock

- (void)test
{
    NSLog(@"captrue static variable in block");

    static int height = 170;
    void (^personInfoBlock)(void) = ^() {
        NSLog(@"height is %d", height);
    };
    
    height = 180;
    personInfoBlock();
}

@end
