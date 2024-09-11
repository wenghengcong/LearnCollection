//
//  ViewController.m
//  ExpandButton
//
//  Created by Nemo on 2024/9/6.
//

#import "ViewController.h"

@interface ExpandButton : UIButton

@end

@implementation ExpandButton

// 也可以在hitTest方法里判断
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 检查点击位置是否在扩大后的区域内
    CGRect expandRect = CGRectInset(self.bounds, -20, -20); // 向外扩展 20 像素
    if (CGRectContainsPoint(expandRect, point)) {
        return YES;
    }
    return NO;
}

@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat expandLength = 20;
    ExpandButton *expandButton = [[ExpandButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    CGRect expandRect = CGRectInset(expandButton.frame, -20, -20); // 向外扩展 20 像素
    expandButton.backgroundColor = [UIColor redColor];
    [expandButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backView = [[UIView alloc] initWithFrame:expandRect];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.alpha = 0.3;
    [self.view addSubview: backView];
    [self.view addSubview: expandButton];
}

- (void)clickButton {
    NSLog(@"click button");
}

@end
