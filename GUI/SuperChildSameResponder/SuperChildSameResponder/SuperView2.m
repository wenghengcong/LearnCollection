//
//  SuperView2.m
//  SuperChildSameResponder
//
//  Created by Nemo on 2024/9/6.
//

#import "SuperView2.h"
#import "ChildView.h"

@interface SuperView2()

@property (nonatomic, assign) BOOL hasHandledTouch;

@end

@implementation SuperView2

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *defaultView = [super hitTest:point withEvent:event];
    NSTimeInterval time = CACurrentMediaTime();
    NSLog(@"hitTest-%@-%f", NSStringFromClass(defaultView.class), time);
    if ([defaultView isKindOfClass:[ChildView class]]) {
        // 点击子视图，父视图同时响应
        if (self.hasHandledTouch == NO) {
            [self handleTouchClickChildView];
            self.hasHandledTouch = YES;
        }
    }
    return defaultView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"super view touchesBegan");
    // 确保将事件传递给下一个响应者
    [super touchesBegan:touches withEvent:event];
    self.hasHandledTouch = NO;
}

- (void)handleTouchClickChildView {
    NSLog(@"super view touch handle");
}

@end
