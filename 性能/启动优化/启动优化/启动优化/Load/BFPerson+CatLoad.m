//
//  BFPerson+CatLoad.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPerson.h"
#import "BFPerson+CatLoad.h"

@implementation BFPerson (CatLoad)

+ (void)load
{
    NSLog(@"BFPerson category +load");
    usleep(1000 * 49);
}

@end
