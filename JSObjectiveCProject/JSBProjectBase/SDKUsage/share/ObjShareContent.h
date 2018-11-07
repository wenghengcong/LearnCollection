//
//  ObjShareContent.h
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/21.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjShareContent : NSObject

@property   (nonatomic, copy)   NSString    *shareUrl;
@property   (nonatomic, copy)   NSString    *shareImageUrl;
@property   (nonatomic, strong) UIImage     *shareImage;
@property   (nonatomic, copy)   NSString    *shareContent;
@property   (nonatomic, copy)   NSString    *shareTitle;

@end
