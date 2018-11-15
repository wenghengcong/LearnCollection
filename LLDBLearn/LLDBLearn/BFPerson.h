//
//  BFPerson.h
//  LLDBLearn
//
//  Created by 翁恒丛 on 2018/11/14.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFPerson : NSObject

@property (nonatomic, copy) NSString*     name;

@property (nonatomic, assign) NSInteger     age;

- (void)test;

- (void)eat:(NSString*)food;

@end
