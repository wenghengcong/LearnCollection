//
//  CaptureAutoBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureAutoBlock.h"

@implementation CaptureAutoBlock

int height = 170;
- (void)test
{
    NSLog(@"captrue auto variable in block");
    auto int weight = 66;
    void (^personInfoBlock)(void) = ^() {
        NSLog(@"height is %d, weight is %d", height, weight);
    };
    
    void (^bmiBlock)(int, int) = ^(int height, int weight) {
        NSLog(@"height is %d, weight is %d", height, weight);
    };
    
    height = 180;
    weight = 60;
    
    personInfoBlock();
    bmiBlock(height, weight);
}

@end
