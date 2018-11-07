//
//  UIViewController+JS.m
//  timeboy
//
//  Created by wenghengcong on 15/6/6.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIViewController+Tool.h"

@implementation UIViewController(JS)


#pragma mark- recursive description
-(NSString*)recursiveDescription
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"\n"];
    [self addDescriptionToString:description indentLevel:0];
    
    //    NSString *info = [NSString stringWithFormat:@"%s [Line %d] \r\r %@ \r\r %@ \r %@",
    //                      __PRETTY_FUNCTION__, __LINE__,
    //                      [self performSelector:@selector(recursiveDescription)],
    //                      [[self constraints] description],
    //                      [self performSelector:@selector(_autolayoutTrace)]];
    return description;
}

-(void)addDescriptionToString:(NSMutableString*)string indentLevel:(NSInteger)indentLevel
{
    NSString *padding = [@"" stringByPaddingToLength:indentLevel withString:@" " startingAtIndex:0];
    [string appendString:padding];
    [string appendFormat:@"%@, %@",[self debugDescription],NSStringFromCGRect(self.view.frame)];
    
    for (UIViewController *childController in self.childViewControllers)
    {
        [string appendFormat:@"\n%@>",padding];
        [childController addDescriptionToString:string indentLevel:indentLevel + 1];
    }
}


#pragma mark- visible
- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}



@end
