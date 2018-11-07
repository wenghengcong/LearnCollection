//
//  ObjUser.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/2.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

/**
 *  自解析Model使用方法
 *  1.property只能是对象，对于NSInterger、CGFloat等均转换为NSNumber对象，使用也更方便；
 *  2.在.m实现文件中，要重写initWithDirectory方法，并在其中实现对字典字段到@propety的转换；
 *  3.注意对象中包含对象，以及对BOOL值读取的方法
 */


#import "ObjBase.h"
#import "ObjUserPhone.h"


@interface ObjUser : ObjBase

@property (nonatomic ,assign)NSNumber               *user_id;
@property (nonatomic ,copy)NSString                 *user_name;
@property (strong ,nonatomic)ObjUserPhone           *user_phone;
@property (assign,getter=isVip,nonatomic)BOOL       vip;

@end
