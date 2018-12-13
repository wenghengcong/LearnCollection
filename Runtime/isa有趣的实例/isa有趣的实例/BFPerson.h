//
//  BFPerson.h
//  关于isa有趣的实例
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject
@property (nonatomic, copy) NSString * name;
- (void)print;
@end

NS_ASSUME_NONNULL_END
