//
//  ViewController.m
//  AssociatedObjectDemo
//
//  Created by WengHengcong on 2018/12/2.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
#import "BFPerson+BFBoy.h"

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
    person.age = 28;
    NSLog(@"person age %ld", (long)person.age);
}

@end
