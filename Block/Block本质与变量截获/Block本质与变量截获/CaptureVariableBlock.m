//
//  CaptureVariableBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/4.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureVariableBlock.h"

@implementation CaptureVariableBlock

int age = 28;

- (void)test
{
    double weight = 66;
    static int height = 170;
    
    const char *lastname = "weng";
    
    void (^personInfoBlock)(void) = ^() {
        NSLog(@"lastname %s, age is %d,", lastname, age);
        NSLog(@"height is %d, weight is %f", height, weight);
    };
    
    personInfoBlock();
}

@end
