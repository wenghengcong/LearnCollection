//
//  BFStudent+CatLoad.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFStudent+CatLoad.h"

@implementation BFStudent (CatLoad)

+ (void)load
{
    NSLog(@"BFStudent category +load");
    usleep(1000 * 67);
}
@end
