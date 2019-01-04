//
//  ViewController.m
//  内存布局
//
//  Created by WengHengcong on 2019/1/3.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

int a = 10;
int b;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static int c = 20;
    static int d;
    int e;
    int f = 20;
    
    NSString *str = @"123";
    NSObject *obj1 = [[NSObject alloc] init];
    NSObject *obj2 = [[NSObject alloc] init];
    NSLog(@"\n&a=%p\n&b=%p\n&c=%p\n&d=%p\n&e=%p\n&f=%p\nstr=%p\nobj1=%p\nobj2=%p\n",
          &a, &b, &c, &d, &e, &f, str, obj1, obj2);
}
/*
 iOS 真机下地址
 字符串常量
 str = 0x10062c068
 
 已初始化的全局变量、静态变量
 &a = 0x10062cd98
 &c = 0x10062cd9c
 
 未初始化的全局变量、静态变量
 &d = 0x10062ce60
 &b = 0x10062ce64
 
 堆
 obj1 = 0x1c0002240
 obj2 = 0x1c0002200
 
 栈
 &f = 0x16f7d9358
 &e = 0x16f7d935c
 */
@end
