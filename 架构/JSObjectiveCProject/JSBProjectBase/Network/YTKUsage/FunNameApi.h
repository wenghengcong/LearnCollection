//
//  FunNameApi.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "YTKRequest.h"

@interface FunNameApi : YTKRequest

/**
 *  初始化api，参数
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password;

/**
 *  返回结果中的userId
 *
 *  @return <#return value description#>
 */
- (NSString *)userId;
@end
