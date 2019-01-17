//
//  CaptureStaticBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureStaticBlock.h"

@implementation CaptureStaticBlock

static int vision = 5;
- (void)test
{
    NSLog(@"captrue static variable in block");
    static const int height = 170;
    static int weight = 60;
    const int good = 5;
    void (^personInfoBlock)(void) = ^() {
        weight = 70;
        vision = 4;
        NSLog(@"vision is %d, height is %d, weight is %d", vision, height, weight);
    };
    
//    weight = 80;
//    vision = 3;
    personInfoBlock();
}

@end
