//
//  UIFont+JSBProject.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/5.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "UIFont+Project.h"

@implementation UIFont (Project)

+ (UIFont *)tinySizeSystemFont
{
    return [UIFont systemFontOfSize:TinyFontSize];
}

+ (UIFont *)smallSizeSystemFont
{
    return [UIFont systemFontOfSize:SmallFontSize];
}

+ (UIFont *)middleSizeSystemFont
{
    return [UIFont systemFontOfSize:MiddleFontSize];
}

+ (UIFont *)largeSizeSystemFont
{
    return [UIFont systemFontOfSize:LargeFontSize];
}

+ (UIFont *)hugeSizeSystemFont
{
    return [UIFont systemFontOfSize:HugeFontSize];
}

//加粗
+ (UIFont *)tinySizeBoldSystemFont
{
    return [UIFont boldSystemFontOfSize:TinyFontSize];
}

+ (UIFont *)smallSizeBoldSystemFont
{
    return [UIFont boldSystemFontOfSize:SmallFontSize];
}

+ (UIFont *)middleSizeBoldSystemFont
{
    return [UIFont boldSystemFontOfSize:MiddleFontSize];
}

+ (UIFont *)largeSizeBoldSystemFont
{
    return [UIFont boldSystemFontOfSize:LargeFontSize];
}

+ (UIFont *)hugeSizeBoldSystemFont
{
    return [UIFont boldSystemFontOfSize:HugeFontSize];
}

@end
