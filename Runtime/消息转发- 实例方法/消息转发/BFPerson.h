//
//  BFPerson.h
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject

- (void)eat;

- (NSString *)eat:(NSString *)food;

- (int)learnedNum;

- (NSString *)learn:(NSString *)lesson;

- (NSArray *)learnALot;

@end

NS_ASSUME_NONNULL_END
