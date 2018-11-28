//
//  BFPerson.m
//  KVO
//
//  Created by WengHengcong on 2018/11/26.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson


/**
 针对每个属性，KVO都会生成一个‘+ (BOOL)automaticallyNotifiesObserversOfXXX’方法，
 返回是否可以自动调用KVO
 */
+ (BOOL)automaticallyNotifiesObserversOfAge
{
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversOfName
{
    return YES;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    BOOL automatic = NO;
    if ([key isEqualToString:@"age"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}


/**
 如果age改变
 观察者也会收到name改变的通知
 */
+ (NSSet<NSString *> *)keyPathsForValuesAffectingAge
{
    NSSet *set = [NSSet setWithObjects:@"name", nil];
    return set;
}

- (void)setAge:(NSInteger)age
{
    if (_age != age) {
        [self willChangeValueForKey:@"age"];
        _age = age;
        [self didChangeValueForKey:@"age"];
    }
}

@end
