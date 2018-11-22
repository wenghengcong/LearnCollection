//
//  BFTeacher.h
//  BFOCClass分类
//
//  Created by WengHengcong on 2018/11/22.
//  Copyright © 2018 LuCI. All rights reserved.
//

#import "BFPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFTeacher : BFPerson


@property (nonatomic, copy) NSString * subject;

- (void)teacherIntanceMethod;

+ (void)teacherClassMethod;

@end

NS_ASSUME_NONNULL_END
