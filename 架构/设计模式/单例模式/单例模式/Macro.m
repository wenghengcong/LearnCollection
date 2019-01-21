//
//  Macro.m
//  单例模式
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "Macro.h"

#define Singleton_IMPLEMENTATION(className) \
static className *_instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
\
return _instace; \
} \
\
+ (instancetype)shared##className \
{ \
if (_instace == nil) { \
_instace = [[className alloc] init]; \
} \
\
return _instace; \
}
