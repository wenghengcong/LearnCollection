//
//  FontUsage.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "FontUsage.h"

@implementation FontUsage

- (void)printSystemFonts {
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        
    }
    
}

- (void)howToUseAddingFont {
    
    //注意:打印出的字体名并不与字体文件名一致,也不与安装字体后在字体册中看到的名字一致,所以要仔细辨别新添加的是哪个字体,在这里打印出的字体名才是我们需要的.
    
    //xx.font = [UIFont fontWithName:@"Avenir-Book" size:20.0];
    
}
@end
