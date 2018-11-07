//
//  ObjBook.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjBook.h"

@implementation ObjBook

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    //property-->json解析
    return @{
             @"book_name" : @"name",
             @"book_isbn":@"isbn",
             @"book_price":@"price",
             };
    
}


/**
 *  等待json转换为对象后，调用该方法
 */
- (void)keyValuesDidFinishConvertingToObject {
    self.book_price = self.book_price/100;
}

@end
