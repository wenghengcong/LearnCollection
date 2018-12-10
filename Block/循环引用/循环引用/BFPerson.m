//
//  BFPerson.m
//  循环引用
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

- (void)dealloc
{
//    [super dealloc];
    NSLog(@"%s", __func__);
}
@end
