//
//  Book.h
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Book : NSObject
/**
 *  书名
 */
@property (copy ,nonatomic)NSString             *bookName;
/**
 *  书价
 */
@property (assign ,nonatomic)CGFloat            price;
/**
 *  出版日期
 */
@property (strong ,nonatomic)NSDate             *publishTime;


@end
