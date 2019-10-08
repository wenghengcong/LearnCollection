//
//  RouterDispatchManager.m
//  iOSNotifications
//
//  Created by WengHengcong on 2018/3/8.
//  Copyright © 2018年 WengHengcong. All rights reserved.
//

#import "JSMessageHandler.h"
#import <objc/message.h>

@interface JSMessageHandler()

/**
 处理类隐射表
 */
@property (nonatomic ,strong) NSMutableDictionary *mapper;
@property (nonatomic ,copy) NSString *publicHandleMethodName;

@end

@implementation JSMessageHandler

+ (instancetype) shared
{
    static JSMessageHandler *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (_mapper == nil) {
            _mapper = [[NSMutableDictionary alloc] init];
        }
        _publicHandleMethodName = @"jspushOpenMessageWithUserinfo:";
    }
    return self;
}

+ (void)registerClassName:(NSString *)className withKey:(NSString *)key
{
    NSMutableDictionary *mapper = [[self shared] mapper];
    if (mapper == nil) {
        mapper = [[NSMutableDictionary alloc] init];
    }
    [mapper setObject:className forKey:key];
}

+ (void)handleRouterWithUserinfo:(NSDictionary *)userinfo compeletion:(RouterDispatchCompeletionBlock)compeletion
{
    if (userinfo == nil) {
        compeletion(nil, nil);
        return;
    }
    NSString *key = [userinfo objectForKey:@"key"];
    NSString *className = [[[self shared] mapper] valueForKey:key];

    if (className == nil ) {
        compeletion(nil, nil);
        return;
    }
    id handleClass = NSClassFromString(className);
    SEL handleSelector = @selector(jsMessageOpenServiceWithUserinfo:);
    
    id handleClassInstance = ( ( id (*) (id, SEL)) objc_msgSend) ( (id)[handleClass class], @selector(alloc) );
    handleClassInstance = ( (id (*) (id, SEL)) objc_msgSend) ( (id)handleClassInstance, @selector(init));
    
    ( (void (*) (id, SEL, NSDictionary *)) objc_msgSend) ( (id)handleClassInstance, handleSelector, userinfo);
    compeletion(key, userinfo);
}

- (void)jsMessageOpenServiceWithUserinfo:(NSDictionary *)userinfo
{
    
}

@end
