//
//  ValidationAction.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpActionBase.h"

@interface ValidationAction : JSBHttpPostActionBase

-(id) initWithPhoneNumber:(NSString *) phone_number WithCode:(NSString *) code;;

@end
