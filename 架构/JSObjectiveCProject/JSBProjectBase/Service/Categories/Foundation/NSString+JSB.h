//
//  NSString+Random.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

+(NSString *) randomStringWithLength: (int) len;

/**
 *  删减字符串内前后空格
 */
- (NSString *)stringByTrimmingWhiteSpace;

@end
