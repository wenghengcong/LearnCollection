//
//  CaptureSelfBlock.m
//  Block本质与变量截获
//
//  Created by WengHengcong on 2018/12/3.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "CaptureSelfBlock.h"

@interface CaptureSelfBlock()
@property (nonatomic, assign) int height;
@end

@implementation CaptureSelfBlock

- (void)test
{
    NSLog(@"captrue self in block");
    
    self.height = 170;
    
    NSLog(@"self is %p", self);
    void (^personBlock)(void) = ^() {
        NSLog(@"self is %p", self);
    };
    
    void (^person1Block)(void) = ^() {
        NSLog(@"height is %d", self.height);
    };
    
    void (^person2Block)(void) = ^() {
        NSLog(@"height is %d", self->_height);
    };
    
    self.height = 180;
    
    personBlock();
    person1Block();
    person2Block();
}

@end
