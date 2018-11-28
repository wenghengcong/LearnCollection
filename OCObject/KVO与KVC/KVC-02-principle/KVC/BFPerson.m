//
//  BFPerson.m
//  KVC
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

-(NSInteger)getAge
{
    NSLog(@"getAge");
    return 1;
}

-(NSInteger)age
{
    NSLog(@"age");
    return 2;
}

-(NSInteger)isAge
{
    NSLog(@"isAge");
    return 3;
}

-(NSInteger)_age
{
    NSLog(@"_age");
    return 4;
}

//- (void)setAge:(NSInteger)age
//{
//    NSLog(@"setAge: - %ld", (long)age);
//}

- (void)_setAge:(NSInteger)age
{
    NSLog(@"_setAge: - %ld", (long)age);
}

- (void)_setGood:(int)good
{
    NSLog(@"_setGood: - %d", good);
}

//- (void)willChangeValueForKey:(NSString *)key
//{
//    NSLog(@"willChangeValueForKey - begin - %@", key);
//    [super willChangeValueForKey:key];
//    NSLog(@"willChangeValueForKey - end - %@", key);
//}
//
//- (void)didChangeValueForKey:(NSString *)key
//{
//    NSLog(@"didChangeValueForKey - begin - %@", key);
//    [super didChangeValueForKey:key];
//    NSLog(@"didChangeValueForKey - end - %@", key);
//}

// 默认的返回值就是YES
+ (BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

- (void)test
{
    
}

@end
