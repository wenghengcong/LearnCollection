//
//  ViewController.m
//  ThreadLearn
//
//  Created by 翁恒丛 on 2018/10/19.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self asyncOperationsOnSerialThread];
}

-(void)syncOperationMainThread {
    dispatch_queue_t q = dispatch_get_main_queue();
    NSLog(@"Start");
    dispatch_sync(q, ^{
        NSLog(@"come here baby!");
    });
    NSLog(@"End");
}

- (void)asyncOperationsOnSerialThread {
    dispatch_queue_t q = dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
    NSLog(@"Start");
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"End");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
