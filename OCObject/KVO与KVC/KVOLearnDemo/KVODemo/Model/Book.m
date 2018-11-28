//
//  Book.m
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "Book.h"

@implementation Book

- (void)setPrice:(CGFloat)price
{
    [self willChangeValueForKey:@"price"];
    _price = price;
    [self didChangeValueForKey:@"price"];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"bookName"]) {
        return NO;
    }
    
    return [super automaticallyNotifiesObserversForKey:key];
}

//设置属性依赖
//如果bookName改变，那么观察者也会收到price改变的通知
+ (NSSet *)keyPathsForValuesAffectingBookName
{
    NSSet *set = [NSSet setWithObjects:@"price", nil];
    return set;
}

@end
