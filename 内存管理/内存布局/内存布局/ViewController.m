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

int a = 10; // 全局变量：已初始化
int b;      // 全局变量：未初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static int c = 20;  // 静态变量：已初始化
    static int d;       // 静态变量：未初始化
    int e;              // 自动变量：未初始化
    int f = 20;         // 自动变量：已初始化
    
    NSString *str = @"123";     // 字符串常量
    NSObject *obj1 = [[NSObject alloc] init];       // 自动变量：对象变量
    NSObject *obj2 = [[NSObject alloc] init];
    NSLog(@"\n&a=%p\n&b=%p\n&c=%p\n&d=%p\n&e=%p\n&f=%p\nstr=%p\nobj1=%p\nobj2=%p\n",
          &a, &b, &c, &d, &e, &f, str, obj1, obj2);
}
/*
 iOS 真机下地址
 字符串常量
 str = 0x102418068
 
 已初始化的全局变量、静态变量
 &a = 0x102418d98
 &c = 0x102418d9c
 
 未初始化的全局变量、静态变量
 &d = 0x102418e60
 &b = 0x102418e64
 
 堆
 obj1 = 0x1c0002240
 obj2 = 0x1c0002200
 
 栈
 &f = 0x16d9ed358
 &e = 0x16d9ed35c
 */
@end
