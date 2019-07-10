//
//  ViewController.m
//  BlockInterView
//
//  Created by Hunt on 2019/7/9.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self interview_question_2];
}

- (void)interview_question_1
{
    int mutipler = 6;
    int (^Block)(int) = ^int(int num) {
        return num * mutipler;
    };
    
    mutipler = 4;
    NSLog(@"resutlt is %d", Block(2));
}

- (void)interview_question_2
{
    __block int mutipler = 6;
    int (^Block)(int) = ^int(int num) {
        return num * mutipler;
    };
    
    mutipler = 4;
    NSLog(@"resutlt is %d", Block(2));
}


@end
