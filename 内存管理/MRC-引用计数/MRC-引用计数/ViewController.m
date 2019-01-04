//
//  ViewController.m
//  MRC-引用计数
//
//  Created by WengHengcong on 2019/1/3.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test1];
    [self test2];
}

- (void)test
{
    // 内存泄漏：该释放的对象没有释放
    BFPerson *person = [[BFPerson alloc] init];
}

/*
 测试
- (void)setBook:(BFBook *)book
{
    _book = [book retain];
}
 */
- (void)test1
{
    BFBook *book = [[BFBook alloc] init];   //book: 1
    BFPerson *person1 = [[BFPerson alloc] init];  //pseron: 1
    
    person1.book = book;     //book: 2
    person1.book = book;     //book: 3
    person1.book = book;     //book: 4
    
    [book release];     //book: 3
    [person1 release];  //book: 2
    //内存泄漏，修改test2中方案
}


/**
 改进test1，测试如下实现：
 - (void)setBook:(BFBook *)book
 {
    [_book release];
    _book = [book retain];
 }
 */
- (void)test2
{
    BFBook *book = [[BFBook alloc] init];   //book: 1
    BFPerson *person1 = [[BFPerson alloc] init];  //person: 1
    
    person1.book = book;     //book: 2
    person1.book = book;     //book: 2
    person1.book = book;     //book: 2
    
    NSLog(@"%ld", [book retainCount]);
    [book release];     //book: 1
    [person1 release];  //book: 0
}

@end
