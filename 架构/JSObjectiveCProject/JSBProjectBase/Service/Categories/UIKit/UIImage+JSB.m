//
//  UIImage+Clip.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "UIImage+JSB.h"

@implementation UIImage (JSB)

+ (UIImage *)reduce:(UIImage *)image withMaxSize:(CGSize) maxSize
{
    
    /*
     // 原图的宽高比
     CGFloat img_ratio = image.size.width / image.size.height;
     // 设定的最大大小的宽高比
     CGFloat maxImg_ratio = maxSize.width / maxSize.height;
     
     // 得到最接近最大SIZE的不改变原图宽高比的SIZE
     */
    
    // 从宽和高中取比值最小的比作为缩放标准
    //CGFloat x_ratio = maxSize.width / image.size.width;
    //CGFloat y_ratio = maxSize.height / image.size.height;
    //CGFloat ratio = x_ratio > y_ratio ? y_ratio : x_ratio;
    
    CGSize curSize = image.size;
    CGFloat ratio = 1.0f;
    while ( curSize.width > maxSize.width && curSize.height > maxSize.height )
    {
        curSize = image.size;
        CGFloat nextStep = 0.01;
        ratio = ratio -nextStep;
        curSize.width *= ratio;
        curSize.height *= ratio;
    }
    
    if( ratio < 1.0f )
    {
        // 比我们设定的最大值大的图片，我们才缩
        CGFloat save_width = image.size.width * ratio;
        CGFloat save_height = image.size.height * ratio;
        
        save_width = truncf(save_width);
        save_height = truncf(save_height);
        
        CGSize newSize = CGSizeMake(save_width, save_height);
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(newSize);
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(0, 0, save_width , save_height )];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return scaledImage;
    }
    
    // 否则返回原图
    return image;
}

@end
