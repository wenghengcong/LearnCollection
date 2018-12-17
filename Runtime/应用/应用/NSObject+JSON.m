//
//  NSObject+JSON.m
//  应用
//
//  Created by WengHengcong on 2018/12/17.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "NSObject+JSON.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)

+ (instancetype)bf_objectWithJson:(NSDictionary *)json
{
    id obj = [[self alloc] init];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        
        // 设值
        id value = json[name];
        if ([name isEqualToString:@"ID"]) {
            value = json[@"id"];
        }
        [obj setValue:value forKey:name];
    }
    free(ivars);
    
    return obj;
}
@end
