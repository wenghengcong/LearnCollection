//
//  UIBarButtonItem+JS.m
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIBarButtonItem+Block.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem(Block)

#pragma mark- action
char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";

- (void)performActionBlock {
    
    dispatch_block_t block = self.actionBlock;
    
    if (block)
        block();
    
}

- (BarButtonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemActionBlock);
}

- (void)setActionBlock:(BarButtonActionBlock)actionBlock
{
    
    if (actionBlock != self.actionBlock) {
        [self willChangeValueForKey:@"actionBlock"];
        
        objc_setAssociatedObject(self,
                                 UIBarButtonItemActionBlock,
                                 actionBlock,
                                 OBJC_ASSOCIATION_COPY);
        
        // Sets up the action.
        [self setTarget:self];
        [self setAction:@selector(performActionBlock)];
        
        [self didChangeValueForKey:@"actionBlock"];
    }
}
@end
