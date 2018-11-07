//
//  SignUpAction.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "SignUpAction.h"

@implementation SignUpAction

- (id)initWithPhoneNumber:(NSString *)phone_number Password:(NSString *)password Nickname:(NSString *)nickname ConfirmCode:(NSString *)confirm_code uploadImage:(UIImage *)upload_image {
    
    self = [super initWithActionURLString:@"users/sign_up.json"];
    if( self )
    {
        if( [phone_number length]  > 0 && [password length] > 0  &&
           [nickname length] >  0 && [confirm_code length] > 0 )
        {
            
            self.parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               phone_number , @"phone_num" ,
                               password , @"password" ,
                               nickname, @"nickname",
                               confirm_code,@"confirm_code",
                               @"iphone",@"device_type",
                               @"1",@"auto_login",
                               nil];
            
            self.uploadImage = upload_image;
            self.uploadImageParameterName = @"photo";
            self.isValid = YES;
            
        }
    }
    
    return self;

}

@end
