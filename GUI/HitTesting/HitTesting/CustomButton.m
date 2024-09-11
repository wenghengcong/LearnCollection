//
//  CustomButton.m
//  HitTesting
//
//  Created by Nemo on 2024/9/4.
//

#import "CustomButton.h"

@implementation CustomButton

// 重写drawRect:方法
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    // 设置按钮的背景颜色为蓝色
    [[UIColor blueColor] setFill];
    UIRectFill(rect);

    // 设置内切圆的颜色为红色
    [[UIColor redColor] setFill];

    // 计算内切圆的半径
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2.0;

    // 绘制内切圆
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0)
                                                              radius:radius
                                                          startAngle:0
                                                            endAngle:2 * M_PI
                                                           clockwise:YES];
    [circlePath fill];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat x1 = point.x;
    CGFloat y1 = point.y;

    CGFloat x2 = self.frame.size.width / 2;
    CGFloat y2 = self.frame.size.height / 2;

    // 矩形内切圆可点击
    double dis = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    
    CGPoint insidePos = [self convertPoint:point toView:self];
    if (dis <= self.frame.size.width / 2) {
        NSLog(@"point %@ circle inside %@", NSStringFromCGPoint(insidePos), NSStringFromCGSize(self.bounds.size));
        return YES;
    } else {
        NSLog(@"point %@ circle outside %@", NSStringFromCGPoint(insidePos), NSStringFromCGSize(self.bounds.size));
        return NO;
    }
}

@end
