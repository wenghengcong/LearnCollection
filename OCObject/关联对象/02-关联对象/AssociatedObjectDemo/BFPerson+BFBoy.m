//
//  BFPerson+BFBoy.m
//  AssociatedObjectDemo
//
//  Created by WengHengcong on 2018/12/2.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson+BFBoy.h"
#import <objc/runtime.h>

/*
 api
void objc_setAssociatedObject(id object, const void * key,
                              id value, objc_AssociationPolicy policy);
id objc_getAssociatedObject(id object, const void * key);
void objc_removeAssociatedObjects(id object);
*/

@implementation BFPerson (BFBoy)

- (void)setAge:(NSInteger)age
{
    objc_setAssociatedObject(self, "age", @(age), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)age
{
    return [objc_getAssociatedObject(self, "age") integerValue];
}

@end

