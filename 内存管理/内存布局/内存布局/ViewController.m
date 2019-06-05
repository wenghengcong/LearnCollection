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
    
    NSLog(@"全局变量-已初始化a:(%p) = %d", &a, a);
    NSLog(@"全局变量-未初始化b:(%p) = %d", &b, b);
    NSLog(@"静态变量-已初始化c:(%p) = %d", &c, c);
    NSLog(@"静态变量-未初始化d:(%p) = %d", &d, d);

    NSLog(@"自动变量-已初始化e:(%p) = %d", &e, e);
    NSLog(@"自动变量-未初始化f:(%p) = %d", &f, f);

    //堆上的地址，其实比栈地址更大。但在下图中则不是这样。下图描述的是一般性规则，但在不同的操作系统和编译期实现时，则各有不同，另外在堆中分配地址虚拟内存往往更大。
    NSLog(@"字符串常量str:(%p) = %@", str, str);
    NSLog(@"对象obj1:(%p) = %@", obj1, obj1);
    NSLog(@"对象obj1:(%p) = %@", obj2, obj2);

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
