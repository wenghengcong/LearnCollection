//
//  CaptureAutoBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureAutoBlock.h"

@implementation CaptureAutoBlock

- (void)test
{
    NSLog(@"captrue auto variable in block");

    int height = 170;
    auto double weight = 66;
    
    void (^personInfoBlock)(void) = ^() {
        NSLog(@"height is %d, weight is %f", height, weight);
    };
    
    void (^bmiBlock)(int, double) = ^(int height, double weight) {
        double heightByM = (double)height/100;
        double bmi = weight/(heightByM * heightByM);
        NSLog(@"bmi is %f", bmi);
    };
    
    height = 180;
    weight = 60;
    
    personInfoBlock();
    bmiBlock(height, weight);
}

@end
