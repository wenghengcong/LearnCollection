//
//  BFStudent.h
//  BFOCClass分类
//
//  Created by WengHengcong on 2018/11/22.
//  Copyright © 2018 LuCI. All rights reserved.
//

#import "BFPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFStudent : BFPerson

@property (nonatomic, assign) double score;
@property (nonatomic, copy) NSString *no;

//+ (void)test;

//- (void)test;

@end

NS_ASSUME_NONNULL_END
