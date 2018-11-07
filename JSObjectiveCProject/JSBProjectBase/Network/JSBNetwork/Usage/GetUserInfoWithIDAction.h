//
//  GetUserInfoWithIDAction.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpActionBase.h"

@interface GetUserInfoWithIDAction : JSBHttpGetActionBase

-(id) initWithUserId:(NSNumber *)iD;

@end
