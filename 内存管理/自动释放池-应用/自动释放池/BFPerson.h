//
//  BFPerson.h
//  自动释放池
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFPerson : NSObject

@property (nonatomic, retain) NSString *name;

- (instancetype)initWithName:(NSString *)name;
+ (instancetype)personWithName:(NSString *)name;

@end

