//
//  BFPerson.h
//  copy
//
//  Created by WengHengcong on 2019/1/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
//@property (nonatomic, copy) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *data;

@end

NS_ASSUME_NONNULL_END
