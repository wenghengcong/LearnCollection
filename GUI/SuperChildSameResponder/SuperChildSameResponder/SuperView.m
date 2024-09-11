//
//  SuperView.m
//  SuperChildSameResponder
//
//  Created by Nemo on 2024/9/6.
//

#import "SuperView.h"
#import "ChildView.h"

/// 截获子视图的点击事件
@implementation SuperView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *defaultView = [super hitTest:point withEvent:event];
    NSLog(@"hitTest-%@", NSStringFromClass(defaultView.class));

    if ([defaultView isKindOfClass:[ChildView class]]) {
//        return nil;  //不处理子视图的点击
        return self; //截获子视图点击，变成SuperView的点击，调用其touchesBegan
    }
    return defaultView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"super view touchesBegan");
    // 确保将事件传递给下一个响应者
    [super touchesBegan:touches withEvent:event];
}

@end
