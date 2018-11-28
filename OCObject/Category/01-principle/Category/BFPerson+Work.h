//
//  BFPerson+Work.h
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@interface BFPerson (Work)
@property (nonatomic, assign) double workAge;

- (void)work;
+ (void)workIn:(NSString *)city;
- (void)test;
@end

