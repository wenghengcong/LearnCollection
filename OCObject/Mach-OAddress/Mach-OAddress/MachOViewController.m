//
//  ViewController.m
//  Mach-OAddress
//
//  Created by 翁恒丛 on 2018/10/29.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "MachOViewController.h"


//常量const
const int age = 10;
const double weight;

//静态变量（内部全局变量，定义是全局变量，但只能在该类文件中使用）
static NSString *hometown;
static NSString *livein = @"ShangeHai";

@interface MachOViewController ()
@property (nonatomic ,strong) UIView * addressView;
@end

@implementation MachOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self machoAddressTest];
}

bool male = true;
- (void)machoAddressTest
{
    char *greetMessage = "Hello.";
    printf("Greeting with %s\n", greetMessage);
    
    NSString *firstName = @"weng";
    NSLog(@"My first name is %@\n",firstName);
    
    char * const lastName = "Hengcong";
    NSLog(@"My last name is %s \n", lastName);
    
    NSString *company = [NSString stringWithFormat:@"JD"];
    NSLog(@"My company is %@", company);
}

- (UIView *)addressView
{
    if(_addressView == nil )
    {
        UIView *view = [[UIView alloc] init];
        _addressView = view;
    }
    return _addressView;
}

@end
