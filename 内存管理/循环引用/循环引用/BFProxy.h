//
//  BFProxy.h
//  循环引用
//
//  Created by WengHengcong on 2019/1/8.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 1. 继承自NSProxy，会直接进入转发机制，进入methodSignatureForSelector及forwardInvocation
 2. 发送给BFProxy对象的，都会转发给相应对象，所以注意在调用BFProxy类对象时注意最后都会转发给传进来的target
    //假如self是个控制器ViewController
    BFProxy *proxy = [BFProxy proxyWithTarget:self];
    [proxy isKindOfClass:[UIViewController class]] 最后发送给proxy的消息，都会转发给self，此处就是YES
 */
@interface BFProxy : NSObject
+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic) id target;
@end

NS_ASSUME_NONNULL_END
