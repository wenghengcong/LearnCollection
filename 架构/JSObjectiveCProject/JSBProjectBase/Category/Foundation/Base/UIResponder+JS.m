//
//  UIResponder+JS.m
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIResponder+JS.h"
#define XIB_WIDTH 320


@implementation UIResponder(JS)

#pragma mark- chain
- (NSString *)responderChainDescription
{
    NSMutableArray *responderChainStrings = [NSMutableArray array];
    [responderChainStrings addObject:[self class]];
    UIResponder *nextResponder = self;
    while ((nextResponder = [nextResponder nextResponder])) {
        [responderChainStrings addObject:[nextResponder class]];
    }
    __block NSString *returnString = @"Responder Chain:\n";
    __block int tabCount = 0;
    [responderChainStrings enumerateObjectsWithOptions:NSEnumerationReverse
                                            usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                if (tabCount) {
                                                    returnString = [returnString stringByAppendingString:@"|"];
                                                    for (int i = 0; i < tabCount; i++) {
                                                        returnString = [returnString stringByAppendingString:@"----"];
                                                    }
                                                    returnString = [returnString stringByAppendingString:@" "];
                                                }
                                                else {
                                                    returnString = [returnString stringByAppendingString:@"| "];
                                                }
                                                returnString = [returnString stringByAppendingFormat:@"%@ (%lu)\n", obj, (unsigned long)idx];
                                                tabCount++;
                                            }];
    return returnString;
}


#pragma mark- UIAdapt
CGRect CGAdaptRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //UIScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return CGRectMake(x*scale, y*scale, width *scale, height*scale);
}

CGPoint CGAdaptPointMake(CGFloat x, CGFloat y){
    //UIScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return CGPointMake(x*scale, y*scale);
}

-(CGFloat)factorAdapt{
    //IScreenMode *currentMode = [[UIScreen mainScreen]currentMode];
    CGRect sreenBounds = [UIScreen mainScreen].bounds;
    CGFloat scale  = sreenBounds.size.width/XIB_WIDTH;
    return scale;
}

@end
