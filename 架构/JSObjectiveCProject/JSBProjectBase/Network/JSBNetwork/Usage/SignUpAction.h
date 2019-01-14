//
//  SignUpAction.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpActionBase.h"

@interface SignUpAction : JSBHttpPostActionWithSingleImageBase

/**
 *  new 并且初始化对象
 *
 *  @param phone_number 电话号码
 *  @param password     密码
 *  @param nickname     昵称
 *  @param confirm_code 验证码
 *  @param upload_image 上传的头像图片
 *
 *  @return 返回对象，有效与否看 IsValid 属性
 */
-(id) initWithPhoneNumber:(NSString *) phone_number
                 Password:(NSString *) password
                 Nickname:(NSString *) nickname
              ConfirmCode:(NSString *) confirm_code
              uploadImage:(UIImage *) upload_image;

@end
