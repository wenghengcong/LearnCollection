//
//  UIColor+JS.m
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "UIColor+JS.h"

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor(JS)

#pragma mark- 十六进制颜色

+ (UIColor *)colorWithHexColorInteger:(UInt32)hexColorInteger
{
    return [UIColor colorWithHexColorInteger:hexColorInteger alpha:1];
}

+ (UIColor *)colorWithHexColorInteger:(UInt32)hexColorInteger alpha:(CGFloat)alpha
{

    return [UIColor colorWithRed:((hexColorInteger >> 16) & 0xFF)/255.0
                           green:((hexColorInteger >> 8) & 0xFF)/255.0
                            blue:(hexColorInteger & 0xFF)/255.0
                           alpha:alpha];
}




+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString {
    CGFloat   alpha  , red, blue, green;

    NSString *colorString = [[hexColorString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue  = colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red   = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue  = colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue  = colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red   = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue  = colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    
    UIColor *color = [UIColor colorWithR:red G:green B:blue A:alpha];
    
    return color;
}

- (NSString *)HEXString{
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}


#pragma mark- RGB
+ (UIColor *)colorWithRGBAString:(NSString *)rgbaStr
{
    NSArray *rgba = [rgbaStr componentsSeparatedByString:@","];
    CGFloat r = [rgba[0] floatValue];
    CGFloat g = [rgba[1] floatValue];
    CGFloat b = [rgba[2] floatValue];
    CGFloat a = [rgba[3] floatValue];
    return [UIColor colorWithRed:r/255 green:g/255. blue:b/255. alpha:a];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}




#pragma mark- Random

+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

#pragma mark- gradient

+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height
{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

#pragma mark- web

/// 获取canvas用的颜色字符串
- (NSString *)canvasColorString
{
    CGFloat *arrRGBA = [self getRGB];
    int r = arrRGBA[0] * 255;
    int g = arrRGBA[1] * 255;
    int b = arrRGBA[2] * 255;
    float a = arrRGBA[3];
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", r, g, b, a];
}
/// 获取网页颜色字串
- (NSString *)webColorString
{
    CGFloat *arrRGBA = [self getRGB];
    int r = arrRGBA[0] * 255;
    int g = arrRGBA[1] * 255;
    int b = arrRGBA[2] * 255;
    NSLog(@"%d,%d,%d", r, g, b);
    NSString *webColor = [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
    return webColor;
}

- (CGFloat *) getRGB{
    UIColor * uiColor = self;
    CGColorRef cgColor = [uiColor CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(cgColor);
    if (numComponents == 4){
        static CGFloat * components = Nil;
        components = (CGFloat *) CGColorGetComponents(cgColor);
        return (CGFloat *)components;
    } else { //否则默认返回黑色
        static CGFloat components[4] = {0};
        CGFloat f = 0;
        //非RGB空间的系统颜色单独处理
        if ([uiColor isEqual:[UIColor whiteColor]]) {
            f = 1.0;
        } else if ([uiColor isEqual:[UIColor lightGrayColor]]) {
            f = 0.8;
        } else if ([uiColor isEqual:[UIColor grayColor]]) {
            f = 0.5;
        }
        components[0] = f;
        components[1] = f;
        components[2] = f;
        components[3] = 1.0;
        return (CGFloat *)components;
    }
}

#pragma mark- modify
- (UIColor *)invertedColor{
    NSArray *components = [self componentArray];
    return [UIColor colorWithRed:1-[components[0] doubleValue] green:1-[components[1] doubleValue] blue:1-[components[2] doubleValue] alpha:[components[3] doubleValue]];
}
- (UIColor *)colorForTranslucency{
    CGFloat hue = 0, saturation = 0, brightness = 0, alpha = 0;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation*1.158 brightness:brightness*0.95 alpha:alpha];
}
- (UIColor *)lightenColor:(CGFloat)lighten{
    CGFloat hue = 0, saturation = 0, brightness = 0, alpha = 0;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation*(1-lighten) brightness:brightness*(1+lighten) alpha:alpha];
}
- (UIColor *)darkenColor:(CGFloat)darken{
    CGFloat hue = 0, saturation = 0, brightness = 0, alpha = 0;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation*(1+darken) brightness:brightness*(1-darken) alpha:alpha];
}
- (NSArray *)componentArray{
    CGFloat red, green, blue, alpha;
    const CGFloat *components = CGColorGetComponents([self CGColor]);
    if(CGColorGetNumberOfComponents([self CGColor]) == 2){
        red = components[0];
        green = components[0];
        blue = components[0];
        alpha = components[1];
    }else{
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    return @[@(red), @(green), @(blue), @(alpha)];
}

#pragma is same color

-(BOOL)matchesColor:(UIColor *)color error:(NSError *)error
{
    UIColor *lhs = self;
    UIColor *rhs = color;
    
    if([lhs isEqual:rhs]){ // color model and values are the same
        return YES;
    }
    
    CGFloat red1, red2, green1, alpha1, green2, blue1, blue2, alpha2;
    BOOL lhsSuccess = [lhs getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    BOOL rhsSuccess = [rhs getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    if((!lhsSuccess && rhsSuccess) || (lhsSuccess && !rhsSuccess)){ // one is RGBA, one color not.
        CGFloat r,g,b,a;
        if(!lhsSuccess){ // lhs color could be a monochrome
            const CGFloat *components = CGColorGetComponents(lhs.CGColor);
            if([lhs _colorSpaceModel] == kCGColorSpaceModelMonochrome){
                r = g = b = components[0];
                a = components[1];
                
                return r == red2 && g == green2 && b == blue2 && a == alpha2;
            }
        } else {  // rhs color could be a monochrome
            const CGFloat *components = CGColorGetComponents(rhs.CGColor);
            
            if([rhs _colorSpaceModel] == kCGColorSpaceModelMonochrome){
                r = g = b = components[0];
                a = components[1];
                return r == red1 && g == green1 && b == blue1 && a == alpha1;
            }
        }
        
        
        NSError *aError = [[NSError alloc] initWithDomain:@"UIColorComparision" code:-11111 userInfo:[self _colorComparisionErrorUserInfo]];
        error = aError;
        return  NO;
    } else if (!lhsSuccess && !rhsSuccess){ // both not RGBA, lets try HSBA
        CGFloat hue1,saturation1,brightness1;
        CGFloat hue2,saturation2,brightness2;
        
        lhsSuccess = [lhs getHue:&hue1 saturation:&saturation1 brightness:&brightness1 alpha:&alpha1];
        rhsSuccess = [lhs getHue:&hue2 saturation:&saturation2 brightness:&brightness2 alpha:&alpha2];
        if((!lhsSuccess && rhsSuccess) || (lhsSuccess && !rhsSuccess)){
            NSError *aError = [[NSError alloc] initWithDomain:@"UIColorComparision" code:-11111 userInfo:[self _colorComparisionErrorUserInfo]];
            error = aError;
            return  NO;
        } else if(!lhsSuccess && !rhsSuccess){ // both not HSBA, lets try monochrome
            CGFloat white1, white2;
            
            lhsSuccess = [lhs getWhite:&white1 alpha:&alpha1];
            rhsSuccess = [rhs getWhite:&white2 alpha:&alpha2];
            if((!lhsSuccess && rhsSuccess) || (lhsSuccess && !rhsSuccess)){
                NSError *aError = [[NSError alloc] initWithDomain:@"UIColorComparision" code:-11111 userInfo:[self _colorComparisionErrorUserInfo]];
                error = aError;
                return  NO;
            } else {
                return white1 == white2 && alpha1 == alpha2;
            }
            
        } else {
            return hue1 == hue2 && saturation1 == saturation2 && brightness1 == brightness2 && alpha1 == alpha2;
        }
        
    } else {
        return (red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2);
        
    }
}

-(NSDictionary *)_colorComparisionErrorUserInfo{
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Comparision failed.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The colors models are incompatible. Or the color is a pattern.", nil),
                               
                               };
    return userInfo;
}

- (CGColorSpaceModel)_colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

@end
