//
//  BFPerson.h
//  KVC
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) BFBook  *book;

- (void)test;

@end

NS_ASSUME_NONNULL_END
