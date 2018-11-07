//
//  JSPerson.h
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JSModel.h"
#import "JSDog.h"
#import "JSBook.h"

@interface JSPerson : NSObject

@property (nonatomic ,assign)   NSInteger           age;
@property (nonatomic ,strong)   NSNumber           *height;
@property (nonatomic ,copy)     NSString            *name;
@property (nonatomic ,copy)     NSString            *bio;
@property (nonatomic ,assign)   BOOL                sex;        //0.male 1.female

@property (nonatomic ,strong)   JSDog               *dog;

@property (nonatomic ,strong)   NSArray             *books;     //里面是JSBook对象

@end
