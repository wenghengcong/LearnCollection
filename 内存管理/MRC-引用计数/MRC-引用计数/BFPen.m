//
//  BFPen.m
//  MRC-引用计数
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPen.h"

@implementation BFPen

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
