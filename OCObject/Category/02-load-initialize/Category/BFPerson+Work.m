//
//  BFPerson+Work.m
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson+Work.h"

@implementation BFPerson (Work)

+ (void)load
{
    NSLog(@"+[BFPerson load]--Work Cat");
}

+ (void)initialize
{
    NSLog(@"+[BFPerson initialize]--Work Cat");
}


- (void)work
{
    NSLog(@"-[BFPerson work]--Work Cat");
}

+ (void)workIn:(NSString *)city
{
    NSLog(@"+[BFPerson workIn:]--Work Cat");
}

- (void)test
{
    NSLog(@"-[BFPerson test]--Work Cat");
}

@end
