//
//  TestHttpAction.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "TestHttpAction.h"
#import "SignUpAction.h"
#import "GetUserInfoWithIDAction.h"
#import "ObjUser.h"

@implementation TestHttpAction

- (void)testApi
{
    SignUpAction *signUpAct = [[SignUpAction alloc]initWithPhoneNumber:@"" Password:@"" Nickname:@"" ConfirmCode:@"" uploadImage:nil];
    
    [signUpAct doActionWithSuccess:^(JSBHttpActionBase *action, id responseObject, AFHTTPRequestOperation *operation) {
        
        //请求成功
        
        JSBHttpResponseResult * respone = [JSBHttpResponseResult  createWithResponeObject:responseObject];
        if ([respone getErrorCode] == kServerErrorCode_OK) {
            
        }else{
            
        }
        
        
    } Failure:^(JSBHttpActionBase *action, NSError *error, AFHTTPRequestOperation *operation) {
        
        //请求失败
        
    }];
    
    
    GetUserInfoWithIDAction *getUserAct = [[GetUserInfoWithIDAction alloc]initWithUserId:@1];
    
    [getUserAct doActionWithSuccess:^(JSBHttpActionBase *action, id responseObject, AFHTTPRequestOperation *operation) {
        
        JSBHttpResponseResult *result = [JSBHttpResponseResult createWithResponeObject:responseObject];
        
        if ([result getErrorCode] == kServerErrorCode_OK) {
            ObjUser *user = [[ObjUser alloc]initWithDirectory:[result getResponseFirstObject]];
            
        }else{
            
        }
        
    } Failure:^(JSBHttpActionBase *action, NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

@end
