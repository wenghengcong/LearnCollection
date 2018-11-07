//
//  KeychainUsage.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  keychain使用
 *  1.导入Security.framework;
 *  2.编译项：-fno-objc-arc
 *  3.参考使用方法
 */

@interface KeychainUsage : NSObject

- (void)howToSetKeyChain;

@end
