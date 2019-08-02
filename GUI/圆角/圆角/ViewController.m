//
//  ViewController.m
//  圆角
//
//  Created by Hunt on 2019/8/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Corner.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self clipCorner1];
    [self clipCorner2];
}

- (void)clipCorner1
{
    self.imageView.layer.cornerRadius = 20.0;
    self.imageView.layer.masksToBounds = YES;
}


- (void)clipCorner2
{
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds cornerRadius:20].CGPath;
    self.imageView.layer.mask = mask;
}

- (void)clipCorner3
{
    //重新绘制圆角
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = self.imageView.image;
        image = [image drawCircleImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}


- (void)clipCorner4
{
    
}

#pragma mark - Utils



@end
