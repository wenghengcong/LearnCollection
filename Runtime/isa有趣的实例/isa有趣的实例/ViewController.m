//
//  ViewController.m
//  isa有趣的实例
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *test = @"good";
    int age = 18;
    id cls = [BFPerson class];
    void *obj = &cls;
    [(__bridge id)obj print];
    
    //正常调用
//    BFPerson *person = [[BFPerson alloc] init];
//    [person print];
}
@end
