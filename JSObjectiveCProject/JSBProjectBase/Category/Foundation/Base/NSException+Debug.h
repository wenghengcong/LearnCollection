//
//  NSException+Debug.h
//  CategoryCollection
//
//  Created by whc on 15/7/28.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException(Debug)

- (NSArray *)backtrace;

@end
