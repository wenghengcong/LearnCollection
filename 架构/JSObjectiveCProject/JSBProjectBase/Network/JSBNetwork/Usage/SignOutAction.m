//
//  JSBSignOutAction.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "SignOutAction.h"

@implementation SignOutAction

-(id) init
{
    self = [super initWithActionURLString:@"users/sign_out.json"];
    if( self )
    {
        self.isValid = YES;
    }
    return self;
}

@end
