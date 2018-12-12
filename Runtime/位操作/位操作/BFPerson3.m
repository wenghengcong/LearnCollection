//
//  BFPerson3.m
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson3.h"
#define BFTallMask (1<<0)
#define BFRichMask (1<<1)
#define BFHandsomeMask (1<<2)
#define BFThinMask (1<<3)

@interface BFPerson3()
{
    union {
        int bits;
        
        struct {
            char tall : 4;
            char rich : 4;
            char handsome : 4;
            char thin : 4;
        };
    } _tallRichHandsome;
}

@end

@implementation BFPerson3

- (void)setTall:(BOOL)tall
{
    if (tall) {
        _tallRichHandsome.bits |= BFTallMask;
    } else {
        _tallRichHandsome.bits &= ~BFTallMask;
    }
}

- (BOOL)isTall
{
    return !!(_tallRichHandsome.bits & BFTallMask);
}

- (void)setRich:(BOOL)rich
{
    if (rich) {
        _tallRichHandsome.bits |= BFRichMask;
    } else {
        _tallRichHandsome.bits &= ~BFRichMask;
    }
}

- (BOOL)isRich
{
    return !!(_tallRichHandsome.bits & BFRichMask);
}

- (void)setHandsome:(BOOL)handsome
{
    if (handsome) {
        _tallRichHandsome.bits |= BFHandsomeMask;
    } else {
        _tallRichHandsome.bits &= ~BFHandsomeMask;
    }
}

- (BOOL)isHandsome
{
    return !!(_tallRichHandsome.bits & BFHandsomeMask);
}



- (void)setThin:(BOOL)thin
{
    if (thin) {
        _tallRichHandsome.bits |= BFThinMask;
    } else {
        _tallRichHandsome.bits &= ~BFThinMask;
    }
}

- (BOOL)isThin
{
    return !!(_tallRichHandsome.bits & BFThinMask);
}

@end
