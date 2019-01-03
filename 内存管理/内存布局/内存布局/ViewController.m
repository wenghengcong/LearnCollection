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

int a = 10;
int b;

@implementation ViewController

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
 字符串常量
 str = 0x10c4aa068
 
 已初始化的全局变量、静态变量
 &a = 0x10c4aad98
 &c = 0x10c4aad9c
 
 未初始化的全局变量、静态变量
 &d = 0x10c4aae60
 &b = 0x10c4aae64
 
 堆
 obj1 = 0x600001e6cab0
 obj2 = 0x600001e6cac0
 
 栈
 &f = 0x7ffee3754940
 &e = 0x7ffee3754944
 */
@end
