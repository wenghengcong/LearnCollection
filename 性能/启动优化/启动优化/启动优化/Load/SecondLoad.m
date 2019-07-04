//
//  SecondLoad.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "SecondLoad.h"

@implementation SecondLoad

+ (void)load
{
    NSLog(@"Second +load");
    usleep(1000 * 90);
}

@end
