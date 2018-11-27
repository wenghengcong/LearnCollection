//
//  NSKVONotifying_BFPerson.m
//  KVO
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "NSKVONotifying_BFPerson.h"
#import "BFPerson.h"

@implementation NSKVONotifying_BFPerson

- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
    [self willChangeValueForKey:@"age"];
    //调用 原来setter实现
    [self didChangeValueForKey:@"age"];
}

// 伪代码
void _NSSetLongLongValueAndNotify()
{
    [self willChangeValueForKey:@"age"];
    //super执行的是BFPerson，调用的是[BFPerson setAge:]
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key
{
    // 通知观察者，key属性值发生了改变，并将对应的change传入
    // oberser此处是ViewController对象
    [oberser observeValueForKeyPath:key ofObject:self change:@{old: , new: } context:nil];
}

// 屏幕内部实现，隐藏了NSKVONotifying_BFPerson类的存在
- (Class)class
{
    return [BFPerson class];
}

- (BOOL)_isKVOA
{
    return YES;
}

- (void)dealloc
{
    // 清理工作
}
@end
