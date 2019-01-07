//
//  BFProxyOfNSObject.h
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFProxyOfNSObject : NSObject

+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic) id target;

@end

NS_ASSUME_NONNULL_END
