//
//  ViewController.m
//  消息转发
//
//  Created by WengHengcong on 2018/12/14.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BFPerson *person = [[BFPerson alloc] init];
    NSLog(@"person is %@-%p", person, person);
    
    [person eat];               //测试消息转发流程
    [person eat:@"apple"];      //测试消息转发参数
    
//    int num = [person learnedNum];
    [person learn:@"english"];
    
//    NSLog(@"1----");
    NSArray *alot = [person learnALot];  //测试消息转发返回值
//    NSLog(@"3----");
}

@end
