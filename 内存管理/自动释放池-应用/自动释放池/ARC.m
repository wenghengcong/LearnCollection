//
//  ARC.m
//  自动释放池
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ARC.h"
#import "BFPerson.h"

@implementation ARC

- (void)test
{
    __autoreleasing BFPerson *pserson = [[BFPerson alloc] init];
    
    @autoreleasepool {
        NSString *str = [[NSString alloc] initWithFormat:@"worldworldworldworld"];
        NSLog(@"%@", str);
    }
}

- (void)test1
{
    //在 ARC 下，我们并不需要手动调用 autorelease 有关的方法，甚至可以完全不知道 autorelease 的存在，就可以正确管理好内存。因为 Cocoa Touch 的 Runloop 中，每个 runloop circle 中系统都自动加入了 Autorelease Pool 的创建和释放。
    
    //当我们需要创建和销毁大量的对象时，使用手动创建的 autoreleasepool 可以有效的避免内存峰值的出现。因为如果不手动创建的话，外层系统创建的 pool 会在整个 runloop circle 结束之后才进行 drain，手动创建的话，会在 block 结束之后就进行 drain 操作。
    for (int i = 0; i < 100000000; i++) {
        @autoreleasepool {
            NSString* string = @"a b c";
            NSArray* array = [string componentsSeparatedByString:string];
            //....array
        }
    }
}

@end
