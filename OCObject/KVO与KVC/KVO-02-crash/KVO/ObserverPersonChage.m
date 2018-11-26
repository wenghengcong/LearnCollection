//
//  ObserverPersonChage.m
//  KVO
//
//  Created by WengHengcong on 2018/11/26.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ObserverPersonChage.h"

@implementation ObserverPersonChage


/**
 1. 若未实现该方法，注册之后，被观察的对象，如果有对应属性更改，则会导致Crash
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%s---监听到%@的%@属性值改变了 - %@ - %@", __func__, object, keyPath, change, context);
}

@end
