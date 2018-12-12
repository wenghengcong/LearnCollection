//
//  BFPerson1.m
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

// 掩码，一般用来按位与(&)运算的
//#define BFTallMask 1
//#define BFRichMask 2
//#define BFTallMask 4

//#define BFTallMask 0b00000001
//#define BFRichMask 0b00000010
//#define BFHandsomeMask 0b00000100

#define BFTallMask (1<<0)
#define BFRichMask (1<<1)
#define BFHandsomeMask (1<<2)

#import "BFPerson1.h"

@interface BFPerson1()
{
    char _bits;
}
@end

@implementation BFPerson1

- (instancetype)init
{
    if (self = [super init]) {
        _bits = 0b00000100;
    }
    return self;
}

- (void)setTall:(BOOL)tall
{
    if (tall) {
        _bits |= BFTallMask;
    } else {
        _bits &= ~BFTallMask;
    }
}

- (BOOL)isTall
{
    return !!(_bits & BFTallMask);
}

- (void)setRich:(BOOL)rich
{
    if (rich) {
        _bits |= BFRichMask;
    } else {
        _bits &= ~BFRichMask;
    }
}

- (BOOL)isRich
{
    return !!(_bits & BFRichMask);
}

- (void)setHandsome:(BOOL)handsome
{
    if (handsome) {
        _bits |= BFHandsomeMask;
    } else {
        _bits &= ~BFHandsomeMask;
    }
}

- (BOOL)isHandsome
{
    return !!(_bits & BFHandsomeMask);
}

@end

