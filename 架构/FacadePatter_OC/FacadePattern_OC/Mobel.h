//
//  Mobel.h
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mobel : NSObject

@property (nonatomic, assign) NSNumber *price;
@property (nonatomic, copy) NSString *brand;

- (Mobel *)init;
@end
