//
//  BFPerson.h
//  应用
//
//  Created by WengHengcong on 2018/12/17.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, assign) int age;

@property (nonatomic, copy) NSString *name;

- (void)eat;
- (void)run;
- (void)learn;

@end

NS_ASSUME_NONNULL_END
