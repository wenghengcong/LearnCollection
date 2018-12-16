//
//  BFPerson.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"
#import <objc/runtime.h>

@interface BFPerson()
@property (nonatomic ,strong)NSMutableDictionary    *backingStore;
@end

@implementation BFPerson

// 提醒编译器不要自动生成setter和getter的实现、不要自动生成成员变量
@dynamic name;

//- (void)setName:(NSString *)name
//{
//    _name = name;
//}
//
//- (NSString *)name
//{
//    return _name;
//}

- (instancetype)init {
    if (self == [super init]) {
        _backingStore = [NSMutableDictionary dictionary];
    }
    return self;
}

id dynamicGetterNameMethodIMP(id self, SEL _cmd) {
    BFPerson *typepdSelf = (BFPerson*)self;
    NSMutableDictionary *backingStore = typepdSelf.backingStore;
    NSString *key = NSStringFromSelector(_cmd);
    return [backingStore objectForKey:key];
}

void dynamicSetterNameMethodIMP(id self, SEL _cmd, id value) {
    
    BFPerson *typepdSelf = (BFPerson*)self;
    NSMutableDictionary *backingStore = typepdSelf.backingStore;
    
    //setName:
    //将setName转换为name
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    
    //去掉末尾的‘:’
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
    //去掉开头的‘set‘’
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    //首字母小写
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    if (value) {
        [backingStore setObject:value forKey:key];
    }else{
        [backingStore removeObjectForKey:key];
    }
}

//实现name动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)selector {
    
    NSString *selectorString = NSStringFromSelector(selector);
    if ([[selectorString lowercaseString] containsString:@"name"]/* selector is from a @dynamic property */) {
        if ([selectorString hasPrefix:@"set"]) {
            class_addMethod(self, selector, (IMP)dynamicSetterNameMethodIMP, "v@:@");
        }else{
            class_addMethod(self, selector, (IMP)dynamicGetterNameMethodIMP, "@@:@");
        }
        return YES;
    }
    return [super resolveInstanceMethod:selector];
}


@end
