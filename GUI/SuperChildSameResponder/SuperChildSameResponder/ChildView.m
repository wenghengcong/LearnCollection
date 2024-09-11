//
//  ChildView.m
//  SuperChildSameResponder
//
//  Created by Nemo on 2024/9/6.
//

#import "ChildView.h"

@implementation ChildView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"child view touch");
    [super touchesBegan:touches withEvent:event];
}

@end
