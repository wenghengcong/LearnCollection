//
//  BlockStruct.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/4.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BlockStruct.h"

@implementation BlockStruct

- (void)test
{
    void (^helloBlock)(void) = ^() {
        NSLog(@"Hello world");
    };
    
    helloBlock();
}

@end
