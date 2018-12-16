//
//  ViewController.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/14.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFBoy.h"
#import "BFGirl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //测试实例方法的动态解析
    BFBoy *boy = [[BFBoy alloc] init];
    [boy eat];

    //测试类方法的动态解析
    [BFGirl learn];
    
    //测试@dynimac和动态方法解析的配合使用
    BFPerson *person = [[BFPerson alloc] init];
    person.name = @"weng";
    NSLog(@"name is %@", person.name);
    
}


@end
