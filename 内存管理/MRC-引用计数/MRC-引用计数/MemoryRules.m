//
//  MemoryRules.m
//  MRC-引用计数
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "MemoryRules.h"

@implementation MemoryRules

- (void)rule1
{
    /*
     * 自己生成并持有该对象
     */
    id obj0 = [[NSObject alloc] init];
    id obj1 = [NSObject new];
}

- (void)rule2
{
    /*
     * 持有非自己生成的对象
     */
    id obj = [NSArray array]; // 非自己生成的对象，且该对象存在，但自己不持有
    [obj retain]; // 自己持有对象
}

- (void)rule3
{
    /*
     * 不在需要自己持有的对象的时候，释放
     */
    id obj = [[NSObject alloc] init]; // 此时持有对象
    [obj release]; // 释放对象
    /*
     * 指向对象的指针仍就被保留在obj这个变量中
     * 但对象已经释放，不可访问
     */
}

- (void)rule4
{
    /*
     * 非自己持有的对象无法释放
     */
    id obj = [NSArray array]; // 非自己生成的对象，且该对象存在，但自己不持有
    // 此时将运行时crash 或编译器报error
    // MRC 下，调用该方法会导致编译器报issues。此操作的行为是未定义的，可能会导致运行时crash或者其它未知行为
    [obj release];
    
    /*
     其中 非自己生成的对象，且该对象存在，但自己不持有 这个特性是使用autorelease来实现的，示例代码如下：
     
     - (id) getAObjNotRetain {
        id obj = [[NSObject alloc] init]; // 自己持有对象
        [obj autorelease]; // 取得的对象存在，但自己不持有该对象
        return obj;
     }
     
     autorelease 使得对象在超出生命周期后能正确的被释放(通过调用release方法)。
     在调用 release 后，对象会被立即释放，而调用 autorelease 后，对象不会被立即释放，而是注册到 autoreleasepool 中，经过一段时间后 pool结束，此时调用release方法，对象被释放。
     */
}

@end
