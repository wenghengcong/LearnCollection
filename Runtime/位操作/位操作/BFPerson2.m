//
//  BFPerson2.m
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson2.h"

@interface BFPerson2()
{
    // 位域
    struct {
        char tall : 1;
        char rich : 1;
        char handsome : 1;
    } _bits;
}

@end

@implementation BFPerson2

- (void)setTall:(BOOL)tall
{
    _bits.tall = tall;
}

- (BOOL)isTall
{
    return !!_bits.tall;
}

- (void)setRich:(BOOL)rich
{
    _bits.rich = rich;
}

- (BOOL)isRich
{
    return !!_bits.rich;
}

- (void)setHandsome:(BOOL)handsome
{
    _bits.handsome = handsome;
}

- (BOOL)isHandsome
{
    return !!_bits.handsome;
}

@end
