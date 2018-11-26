//
//  BFPerson.m
//  KVO
//
//  Created by WengHengcong on 2018/11/26.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"
#import <objc/runtime.h>

@implementation BFPerson

- (void)setAge:(NSInteger)age
{
    NSLog(@"BFPerson setAge: begin");
    _age = age;
    NSLog(@"BFPerson setAge: end");
}

- (void)willChangeValueForKey:(NSString *)key {
    NSLog(@"BFPerson willChangeValueForKey: - begin");
    [super willChangeValueForKey:key];
    NSLog(@"BFPerson willChangeValueForKey: - end");
}
- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"BFPerson didChangeValueForKey: - begin");
    [super didChangeValueForKey:key];
    NSLog(@"BFPerson didChangeValueForKey: - end");
}


- (NSString *)description {
    
    IMP nameIMP = class_getMethodImplementation(object_getClass(self), @selector(setName:));
    IMP ageIMP = class_getMethodImplementation(object_getClass(self), @selector(setAge:));
    NSLog(@"object address (%p) || object setName: IMP (%p) || object setAge: IMP (%p_ \n",self, nameIMP, ageIMP);
    
    Class objectMethodClass = [self class];
    Class objectRuntimeClass = object_getClass(self);
    Class superClass = class_getSuperclass(objectRuntimeClass);
    NSLog(@"objectMethodClass (%@) || ObjectRuntimeClass (%@) || superClass  (%@) \n", objectMethodClass, objectRuntimeClass, superClass);
    
    unsigned int count;
    Method *methodList = class_copyMethodList(objectRuntimeClass, &count);
    
    NSMutableString *methodNames = [NSMutableString string];
    for (NSInteger i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    NSLog(@"method Name list --- %@", methodNames);
    free(methodList);
    
    return @"";
}

@end
