//
//  ViewController.m
//
//  Created by Nick Lockwood on 03/02/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *layerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //create timing function
    CAMediaTimingFunction *function =
        [CAMediaTimingFunction functionWithName:
         kCAMediaTimingFunctionDefault];
    
    //get control points
    // 修改示例代码为下面这种语法，原先的效果不出来
    float controlPoint1[2];
    float controlPoint2[2];
    
    [function getControlPointAtIndex:1 values:controlPoint1];
    [function getControlPointAtIndex:2 values:controlPoint2];
    
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1)
            controlPoint1:CGPointMake(controlPoint1[0], controlPoint1[1])
            controlPoint2:CGPointMake(controlPoint2[0], controlPoint2[1])];
    
    //scale the path up to a reasonable size for display
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.layerView.layer addSublayer:shapeLayer];
    
    //flip geometry so that 0,0 is in the bottom-left
    self.layerView.layer.geometryFlipped = YES;
}

@end
