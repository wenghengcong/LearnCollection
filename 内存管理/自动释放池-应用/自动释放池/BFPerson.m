//
//  BFPerson.m
//  自动释放池
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

/*
 Autorelease Pool 与函数返回值
 如果一个函数的返回值是指向一个对象的指针，该对象不能在函数return之前release，否则调用者获得的就是野指针。
 在函数return之后也不能立刻release，因为不知道调用者是否retain该对象，若直接release 了，可能导致后面在使用这个对象时它已经成为nil了。
 
 为了解决这个问题， OC中对对象指针的返回值进行了区分，分为retained return value、unretained return value，并且按照“谁拥有谁释放”的原则进行释放。
 retained return value：表示调用者拥有这个返回值，调用者是要负责释放；
 unretained return value：表示调用者不拥有这个返回值，后者不需要进行释放；
 
 按照苹果的命名规则：以 alloc, copy, init, mutableCopy 和 new 这些方法打头的方法，返回的都是 retained return value，例如 [[NSString alloc] initWithFormat:]，
 而其他的则是 unretained return value，例如 [NSString stringWithFormat:]。我们在编写代码时也应该遵守这个 convention。
 */

/**
 retained return value：
 */
- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        // 不需要 autorelease
        self.name = name;
        return self;
    }
    return nil;
}

/**
 unretained return value: 不需要负责释放
 当我们调用非 alloc，init 系的方法来初始化对象时（通常是工厂方法），不需要负责变量的释放，可以当成普通的临时变量来使用
 */
+ (instancetype)personWithName:(NSString *)name
{
    // MRC：需要 autorelease
    // ARC：不需要再调用autorelease
    BFPerson *person = [[[BFPerson alloc] init] autorelease];   //1
    person.name = name;
    return person;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [super dealloc];
}

@end
