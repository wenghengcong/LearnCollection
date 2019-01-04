//
//  ViewController.m
//  自动释放池
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "MRC.h"
#import "ARC.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 Autorelase Pool 提供了一种可以允许你向一个对象延迟发送release消息的机制。
 当你想放弃一个对象的所有权，同时又不希望这个对象立即被释放掉（例如在一个方法中返回一个对象时），Autorelease Pool 的作用就显现出来了。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"begin");
    MRC *mrc = [[MRC alloc] init];
//    [mrc test2];
//    [mrc test3];
    
    ARC *arc = [[ARC alloc] init];
    [arc test];
    [arc test1];
    
    NSLog(@"end");
    
    
}

@end
