//
//  HOMethodInvocationEntity.h
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#import <Foundation/Foundation.h>

@interface HOMethodInvocationEntity : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *cmdName;
@property (nonatomic, assign) NSTimeInterval time;  // ms
@property (nonatomic, strong) NSString *stack;

@end
