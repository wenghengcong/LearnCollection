//
//  BFPerson+Study.h
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson (Study)
@property (nonatomic, copy) NSString *lesson;
@property (nonatomic, assign) NSInteger classNo;

- (void)study;
+ (void)studyLession:(NSString *)les;
- (void)test;
@end

NS_ASSUME_NONNULL_END
