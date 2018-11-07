//
//  ObjUserPhone.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/2.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "ObjUserPhone.h"

@implementation ObjUserPhone

-(id) initWithDirectory:(NSDictionary *) data{
    self = [super initWithDirectory:data];
    if (self) {
        self.country_code = [self  readNumberField:data fieldName:@"country_code"];
        self.national_number = [self readNumberField:data fieldName:@"national_number"];
    }
    return self;
}

@end
