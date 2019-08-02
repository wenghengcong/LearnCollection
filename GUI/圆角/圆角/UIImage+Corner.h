//
//  UIImage+Corner.h
//  圆角
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Corner)

- (UIImage *)drawCircleImage;

- (UIImage *)ho_drawRectWithRoundedCorner:(CGFloat)radius
                                     size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
