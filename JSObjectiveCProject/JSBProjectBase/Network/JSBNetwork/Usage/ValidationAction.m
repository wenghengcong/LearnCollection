//
//  ValidationAction.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "ValidationAction.h"

@implementation ValidationAction

-(id) initWithPhoneNumber:(NSString *) phone_number WithCode:(NSString *) code
{
    self = [super initWithActionURLString:@"users/verification_code.json"];
    if( self )
    {
        if( [phone_number length]  > 0 )
        {
            self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               phone_number , @"phone_num" ,
                               code , @"code",
                               nil];
            
#if defined(XUEXUECAN_DEVELOPMENT) || defined(XUEXUECAN_TEST)||defined(XUEXUECAN_UAT)
            [self.parameters setObject:@1 forKey:@"debug"];
#endif
            self.isValid = YES;
        }
        
    }
    
    return self;
}

@end
