//
//  ViewController.m
//  Block捕获对象
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test];
}

typedef void (^BFBlock)(void);
- (void)test
{
    BFBlock block;
    NSLog(@"begin");
    {
        BFPerson *person = [[BFPerson alloc] init];
        person.age = 28;
        block = ^{
            NSLog(@"age %d", person.age);
        };
    }
    block();
    NSLog(@"class %@", [block class]);
    NSLog(@"end");
}

@end
