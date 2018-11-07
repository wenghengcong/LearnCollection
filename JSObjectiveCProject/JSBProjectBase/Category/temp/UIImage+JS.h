//
//  UIImage+JS.h
//  timeboy
//
//  Created by wenghengcong on 15/4/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (JS)

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

#pragma mark- 加载
+ (UIImage *)imageWithFileName:(NSString *)name;

/**
 *  用颜色初始化一个image
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

#pragma mark- 增强image效果

/**
 *  产生一个模糊的图片:
 *
 *  fuzzy:                                  0~68.5f（范围）
 *
 *  density:                                0~5.0f （范围）
 */
- (UIImage *)blurWithFuzzy:(CGFloat)fuzzy density:(CGFloat)density;

/**
 *  增强Image效果
 */
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


#pragma mark- appha
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

#pragma mark- animated gif
/*
 UIImage *animation = [UIImage animatedImageWithAnimatedGIFData:theData];
 
 I interpret `theData` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 The GIF stores a separate duration for each frame, in units of centiseconds (hundredths of a second).  However, a `UIImage` only has a single, total `duration` property, which is a floating-point number.
 
 To handle this mismatch, I add each source image (from the GIF) to `animation` a varying number of times to match the ratios between the frame durations in the GIF.
 
 For example, suppose the GIF contains three frames.  Frame 0 has duration 3.  Frame 1 has duration 9.  Frame 2 has duration 15.  I divide each duration by the greatest common denominator of all the durations, which is 3, and add each frame the resulting number of times.  Thus `animation` will contain frame 0 3/3 = 1 time, then frame 1 9/3 = 3 times, then frame 2 15/3 = 5 times.  I set `animation.duration` to (3+9+15)/100 = 0.27 seconds.
 */
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;

/*
 UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:theURL];
 
 I interpret the contents of `theURL` as a GIF.  I create an animated `UIImage` using the source images in the GIF.
 
 I operate exactly like `+[UIImage animatedImageWithAnimatedGIFData:]`, except that I read the data from `theURL`.  If `theURL` is not a `file:` URL, you probably want to call me on a background thread or GCD queue to avoid blocking the main thread.
 */
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;



#pragma mark- color
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIColor *)colorAtPoint:(CGPoint )point;
//more accurate method ,colorAtPixel 1x1 pixel
- (UIColor *)colorAtPixel:(CGPoint)point;
//返回该图片是否有透明度通道
- (BOOL)hasAlphaChannel;

///获得灰度图
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

#pragma mark- fx
- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;

- (UIImage *)maskImageFromImageAlpha;

#pragma mark- resize
/**
 * 保持图片纵横比缩放，最短边必须匹配targetSize的大小
 * 可能有一条边的长度会超过targetSize指定的大小
 */
- (UIImage *)imageByScalingAspectToMinSize:(CGSize)targetSize;

/**
 * 保持图片纵横比缩放，最长边匹配targetSize的大小即可
 * 可能有一条边的长度会小于targetSize指定的大小
 */
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize;

/**
 *  不保持图片纵横比缩放
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;


/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedIMageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;



- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;


#pragma mark- roundedcorner
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

#pragma mark- merge
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;


#pragma mark- orientation
/**
 *  修正图片方向
 *
 */
- (UIImage *)fixOrientation;

+ (UIImage *)fixOrientation:(UIImage *)srcImg;
/*垂直翻转*/
- (UIImage *)flipVertical;
/*水平翻转*/
- (UIImage *)flipHorizontal;
/*对图片按弧度执行旋转*/
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/*对图片按角度执行旋转*/
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

#pragma mark- capture
/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)captureWithView:(UIView *)view;
/**
 *  截屏
 */
+ (UIImage *)captureScreen;
/**
 *  从给定UIImage和指定Frame截图：
 */
- (UIImage *)getImageWithSize:(CGRect)myImageRect;
+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage;

@end
