//
//  CaptureVariableBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/4.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureVariableBlock.h"

@interface CaptureVariableBlock()
@property (nonatomic, assign) int foot;
@end

@implementation CaptureVariableBlock

int age = 28;   //全局变量
static float vision = 4.8;  //类静态变量，类m文件可用
- (void)test
{
    self.foot = 5;   //类成员变量
    double weight = 66;     //局部变量，方法内可用
    static int height = 170;        //局部静态变量，方法内可用
    const char *lastname = "weng";  //局部常量，方法内可以
    const int sight = 5;

    void (^personInfoBlock)(void) = ^() {
        NSLog(@"lastname %s, age is %d,", lastname, age);
        NSLog(@"height is %d, weight is %f", height, weight);
        NSLog(@"foot is %d, vision is %f", self.foot, vision);
        NSLog(@"sight %d", sight);
    };
    personInfoBlock();
}

@end
