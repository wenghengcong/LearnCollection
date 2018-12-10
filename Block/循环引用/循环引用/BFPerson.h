//
//  BFPerson.h
//  循环引用
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BFPersonBlock) (void);

@interface BFPerson : NSObject
@property (copy, nonatomic) BFPersonBlock block;
@property (assign, nonatomic) int age;
@end

NS_ASSUME_NONNULL_END
