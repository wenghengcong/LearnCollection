//
//  BFPerson+Work.m
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson+Work.h"

@implementation BFPerson (Work)

- (void)work
{
    NSLog(@"-[BFPerson work]--Wrok Cat");
}

+ (void)workIn:(NSString *)city
{
    NSLog(@"+[BFPerson workIn:]--Wrok Cat");
}

- (void)test
{
    NSLog(@"-[BFPerson test]--Work Cat");
}

@end
