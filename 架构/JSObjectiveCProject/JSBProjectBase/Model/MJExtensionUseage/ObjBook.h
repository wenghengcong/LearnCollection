//
//  ObjBook.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

/**
 *  采用MJExtension解析Model
 */

#import "ObjBase.h"

@interface ObjBook : ObjBase

@property (nonatomic ,copy)NSString             *book_name;
@property (nonatomic ,copy)NSString             *book_isbn;
@property (nonatomic ,assign)NSInteger          book_price;

@end
