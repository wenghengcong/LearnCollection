//
//  FirstLoad.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "FirstLoad.h"

@implementation FirstLoad

+ (void)load
{
    NSLog(@"First +load");
    usleep(1000 * 35);
}

@end
