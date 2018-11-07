//
//  GetUserInfoWithIDAction.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "GetUserInfoWithIDAction.h"

@implementation GetUserInfoWithIDAction

-(id)initWithUserId:(NSNumber *)iD
{
    self = [super initWithActionURLString:[NSString stringWithFormat:@"users/%@.json",iD]];
    if(self)
    {
        self.isValid = YES;
    }
    return self;
}

@end
