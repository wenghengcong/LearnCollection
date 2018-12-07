//
//  CaptureConstBlcok.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/7.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureConstBlcok.h"

@implementation CaptureConstBlcok

const int vision = 5;
- (void)test
{
    NSLog(@"captrue const variable in block");
    const int height = 170;
    void (^personInfoBlock)(void) = ^() {
        NSLog(@"height is %d, vision is %d", height, vision);
    };
    
    personInfoBlock();
}

@end
