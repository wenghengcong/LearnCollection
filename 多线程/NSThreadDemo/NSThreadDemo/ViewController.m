//
//  ViewController.m
//  NSThreadDemo
//
//  Created by Hunt on 2019/7/6.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self createThreadAndAutoStart];
}

- (void)setupView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 40, 100)];
    [self.view addSubview:self.imageView];
}

- (void)createThreadAndManualStart
{
    // 1. 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 2.设置线程的优先级(0.0 - 1.0，1.0最高级)
    thread.threadPriority = 1;

    // 3. 启动线程
    [thread start];    // 线程一启动，就会在线程thread中执行self的run方法
}

- (void)createThreadAndAutoStart
{
    // 1. 创建线程后自动启动线程
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

- (void)implicitCreateThreadAndAutoStart
{
    // 1. 隐式创建并启动线程
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

// 新线程调用方法，里边为需要执行的任务
- (void)run {
    NSLog(@"run %@", [NSThread currentThread]);
}

- (void)NSThreadMethod
{
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread setName:@"run_background_thread"];
    
    // 是否是主线程
    BOOL isMainThread = [thread isMainThread];
    
    // 获得当前线程
    NSThread *current = [NSThread currentThread];
    
    // 获取主线程
    NSThread *mainThread = [NSThread mainThread];
}

- (void)NSThreadState
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];

    // 1. 线程进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
    // - (void)start;
    [thread start];
    
    // 2. 线程进入阻塞状态
    // + (void)sleepUntilDate:(NSDate *)date;
    // + (void)sleepForTimeInterval:(NSTimeInterval)ti;
    [NSThread sleepForTimeInterval:3.0];

    NSDate *date = [NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]];
    [NSThread sleepUntilDate:date];

    
    // 3. 线程进入死亡状态
    // + (void)exit;
    [NSThread exit];
}

- (void)threadCommunication
{
    // 在主线程上执行操作
    // - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
    // - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray<NSString *> *)array;
    // equivalent to the first method with kCFRunLoopCommonModes
    
    // 在指定线程上执行操作
    // - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array NS_AVAILABLE(10_5, 2_0);
    // - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);
    
    // 在当前线程上执行操作，调用 NSObject 的 performSelector:相关方法
    //- (id)performSelector:(SEL)aSelector;
    //- (id)performSelector:(SEL)aSelector withObject:(id)object;
    //- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

    
}

/**
 * 创建一个线程下载图片
 */
- (void)downloadImageOnSubThread {
    // 在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

/**
 * 下载图片，下载完之后回到主线程进行 UI 刷新
 */
- (void)downloadImage {
    
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 1. 获取图片 imageUrl
    NSURL *imageUrl = [NSURL URLWithString:@"https://wiki-1259056568.cos.ap-shanghai.myqcloud.com/ios/20190627101912.png"];
    
    // 2. 从 imageUrl 中读取数据(下载图片) -- 耗时操作
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    // 通过二进制 data 创建 image
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 3. 回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
}

/**
 * 回到主线程进行图片赋值和界面刷新
 */
- (void)refreshOnMainThread:(UIImage *)image {
    NSLog(@"current thread -- %@", [NSThread currentThread]);
    
    // 赋值图片到imageview
    self.imageView.image = image;
}

@end
