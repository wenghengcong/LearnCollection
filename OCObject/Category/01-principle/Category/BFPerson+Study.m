//
//  BFPerson+Study.m
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson+Study.h"

@implementation BFPerson (Study)

- (void)study
{
    NSLog(@"-[BFPerson study]--Study Cat");
}

+ (void)studyLession:(NSString *)les
{
    NSLog(@"+[BFPerson studyLession:]--Study Cat");
}

- (void)test
{
    NSLog(@"-[BFPerson test]--Study Cat");
}

@end
