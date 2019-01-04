//
//  BFPerson.h
//  MRC-引用计数
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFBook.h"
#import "BFPen.h"

@interface BFPerson : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, retain) BFBook *book;

@property (nonatomic, unsafe_unretained) BFPen *pen;

- (void)eat;

@end
