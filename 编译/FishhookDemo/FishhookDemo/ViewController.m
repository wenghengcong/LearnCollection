//
//  ViewController.m
//  FishhookDemo
//
//  Created by Hunt on 2020/8/13.
//

#import "ViewController.h"
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self rebind];
}

//函数指针
static void (*old_nslog)(NSString *format, ...);

//定义一个新的函数
void newNSlog(NSString * format,...){
    format = [format stringByAppendingString:@"hook done! \n"];
    //调用原始的
    old_nslog(format);
}

- (void)rebind {
    // 这里必须要先加载一次NSLog，如果不写NSLog，符号表里面根本就不会出现NSLog的地址
    NSLog(@"hook 前");
    //rebinding结构体
    struct rebinding nslog;
    //需要HOOK的函数名称，C字符串
    nslog.name = "NSLog";
    //新函数的地址
    nslog.replacement = newNSlog;
    //原始函数地址的指针！
    nslog.replaced = (void *)&old_nslog;
    //rebinding结构体数组
    struct rebinding rebs[1] = {nslog};
    /**
     * 参数1 : 存放rebinding结构体的数组
     * 参数2 : 数组的长度
     */
    rebind_symbols(rebs, 1);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了屏幕");
}

@end
