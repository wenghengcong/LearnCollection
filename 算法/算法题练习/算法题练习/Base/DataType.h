//
//  DataType.h
//  算法题练习
//
//  Created by WengHengcong on 2019/1/25.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 链接结点
 */
@interface Node<__covariant ObjectType> : NSObject
// 下一个结点
@property (nonatomic, strong) Node<ObjectType> *next;
// 上一个结点
@property (nonatomic, strong) Node<ObjectType> *prev;
// 数据
@property (nonatomic, strong) ObjectType value;

- (instancetype)initWithValue:(id)value;

@end
