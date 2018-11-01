//
//  ViewController.m
//  LLDBLearn
//
//  Created by 翁恒丛 on 2018/11/1.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int age;
}
@property (nonatomic, strong) NSMutableArray *names;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    age = 3;
    _names = [NSMutableArray arrayWithObjects:@"weng", nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    NSLog(@"names : %@", _names);
    NSLog(@"age is %d", age);
}


@end
