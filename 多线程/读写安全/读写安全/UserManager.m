//
//  UserManager.m
//  读写安全
//
//  Created by Hunt on 2019/7/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "UserManager.h"

@interface UserManager()
{
    // 定义一个并发队列
    dispatch_queue_t concurrent_queue;
    
    // 用户数据, 可能多个线程需要数据访问
    NSMutableDictionary *userDictionary;
}

@end

@implementation UserManager

- (id)init
{
    self = [super init];
    if (self) {
        // 通过宏定义 DISPATCH_QUEUE_CONCURRENT 创建一个并发队列
        concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据容器
        userDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    __block id obj;
    // 同步读取指定数据
    dispatch_sync(concurrent_queue, ^{
        obj = [self->userDictionary objectForKey:key];
    });
    
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key
{
    // 异步栅栏调用设置数据
    dispatch_barrier_async(concurrent_queue, ^{
        [self->userDictionary setObject:obj forKey:key];
    });
}


@end
