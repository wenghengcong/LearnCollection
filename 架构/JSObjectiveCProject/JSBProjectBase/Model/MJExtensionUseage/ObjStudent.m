//
//  ObjStudent.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjStudent.h"

@implementation ObjStudent


+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"stu_name":@"name",
             @"stu_id":@"id",
             @"stu_books":@"books"
             };
}


/**
 *  管理属性中的对象数组
 */
+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"stu_books" : @"ObjBook",
             };
}

@end
