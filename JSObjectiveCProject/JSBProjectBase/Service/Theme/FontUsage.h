//
//  FontUsage.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

/**
 *  添加字体
 *  1.将字体导入项目
 *  2.在info.plist中添加对该字体的支持：Fonts provided by application字段
      Info.plist文件中新建一行(Add Row)，添加key为：UIAppFonts,类型为Array或Dictionary都行；在UIAppFonts下再建立一个键值对,key 为：Item 0,添加Value为XXX.ttf（字体名,string型),可以添加多个.
 *  3.打印系统字体，查看是否已经有该字体
 *  4.正常使用
 */



#import <Foundation/Foundation.h>

@interface FontUsage : NSObject

/**
 *  打印系统字体
 */
- (void)printSystemFonts;

/**
 *  如何使用
 */
- (void)howToUseAddingFont;

@end
