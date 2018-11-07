//
//  ObjStudent.h
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjBase.h"
#import "ObjBook.h"

@interface ObjStudent : ObjBase

@property (nonatomic ,copy)NSString         *stu_name;
@property (nonatomic ,assign)NSInteger      *stu_id;

@property (nonatomic ,strong)NSArray        *stu_books;

@end
