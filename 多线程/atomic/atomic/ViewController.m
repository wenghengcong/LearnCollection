//
//  ViewController.m
//  atomic
//
//  Created by WengHengcong on 2018/12/29.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BFPerson *p = [[BFPerson alloc] init];

    for (int i = 0; i < 10; i++) {
        dispatch_async(NULL, ^{
            // 加锁
            p.data = [NSMutableArray array];
            // 解锁
        });
    }
    
    
    NSMutableArray *array = p.data;
    // 加锁
    [array addObject:@"1"];
    [array addObject:@"2"];
    [array addObject:@"3"];
    // 解锁
}


@end
