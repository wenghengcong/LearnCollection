//
//  FIrstTableController.m
//  NSTimerBestPractice
//
//  Created by Hunt on 2019/7/10.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "FIrstTableController.h"

@interface FIrstTableController ()

@end

@implementation FIrstTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"scrollIdentifier"];
    [self timerInvalidWhenInDefaultMode];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scrollIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--行", (long)indexPath.row];
    return cell;
}

/**
 NSTimer失效
 */
- (void)timerInvalidWhenInDefaultMode
{
    //在滑动时，定时器会停止
    //停止滑动后，恢复定时
    
    // 方式1：创建timer，手动添加到default mode，滑动时定时器停止
//    static int count = 0;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%d", ++count);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode: NSDefaultRunLoopMode];
//
    
    //     方式2：创建timer默认添加到default mode，滑动时定时器停止
    //    static int count = 0;
    // Creates a timer and schedules it on the current run loop in the default mode.
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"%d", ++count);
    //    }];
    
    
    // 解决一：手动添加到两种模式下，即可避免停止
    //    static int count = 0;
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"%d", ++count);
    //    }];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    
    
    // 解决一：添加到_commonModes，RunLoop会自动将timer添加到两种mode下，即可避免停止
    // NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
    // NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
    // timer能在_commonModes数组中存放的模式下工作
    //    static int count = 0;
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"%d", ++count);
    //    }];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //    NSLog(@"%@", [NSRunLoop currentRunLoop]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
}

@end
