//
//  MRC.m
//  自动释放池
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "MRC.h"

@implementation MRC

- (void)test
{
    // 这个对象的 retainCount 会+1，但是并不会发生 release。
    // 当这段语句所处的 autoreleasepool 进行 drain 操作时，所有标记了 autorelease 的对象的 retainCount 会被 -1。
    // 即 release 消息的发送被延迟到 pool 释放的时候了。
    NSString *str = [[[NSString alloc] initWithString:@"hellohellohellohello"] autorelease];
    NSLog(@"%@", str);
}

- (void)test1
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *str = [[NSString alloc] initWithString:@"hellohellohellohello"];
    NSLog(@"%@", str);
    [pool drain];
}


/**
 retained return value：
 */
- (void)test3
{
    BFPerson *person = [[BFPerson alloc] initWithName:@"WengHengcong"];
    self.person = person;
    // 自己持有的对象，一定要释放
    [person release];
}

/**
 unretained return value: 不需要负责释放
 */
- (void)test2
{
    //当我们调用非 alloc，init 系的方法来初始化对象时（通常是工厂方法），不需要负责释放，可以当成普通的临时变量来使用
    BFPerson *person = [BFPerson personWithName:@"WengHengcong"];   //+1
    self.person = person;       //+1
    // 非自己持有的对象，不需要释放
//    [person release];
}


- (void)dealloc
{
    self.person = nil;
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
