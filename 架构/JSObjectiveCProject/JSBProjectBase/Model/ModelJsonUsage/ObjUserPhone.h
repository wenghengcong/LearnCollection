//
//  ObjUserPhone.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/2.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "ObjBase.h"

@interface ObjUserPhone : ObjBase

/**
 *  国家码
 */
@property (nonatomic,strong) NSNumber *country_code;

/**
 *  手机号
 */
@property (nonatomic,strong) NSNumber *national_number;

@end
