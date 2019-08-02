//
//  B.m
//  KVC代码题
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "B.h"
#import <objc/runtime.h>

@implementation B

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)test
{
    NSString *tmp = [self valueForKey:@"_a"];
    NSLog(@"%@", tmp);
    
    unsigned int count;
    //获取方法列表
    Method *methodList = class_copyMethodList([A class], &count);
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method----="">%@", NSStringFromSelector(method_getName(method)));
    }
}

@end
