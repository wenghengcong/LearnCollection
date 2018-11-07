//
//  ObjUser.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/2.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "ObjUser.h"

@implementation ObjUser

- (id)initWithDirectory:(NSDictionary *)data{
    
    self = [super initWithDirectory:data];
    if (self) {
        
        self.user_id = [self readNumberField:data fieldName:@"user_id"];
        self.user_name = [self readStringField:data fieldName:@"username"];
        
        self.user_phone = [[ObjUserPhone alloc]initWithDirectory:[self readDictField:data fieldName:@"user_phone"]];
        self.vip = [self readBoolField:data fieldName:@"vip"];
        
    }
    return self;

}

@end
