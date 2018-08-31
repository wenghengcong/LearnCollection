//
//  ViewController.m
//  BlockLearn
//
//  Created by 翁恒丛 on 2018/8/27.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"

typedef void (^callBlock) (NSString *status);

@interface ViewController ()

@property (nonatomic, copy) void (^printBlock)(NSString *document);
@property (nonatomic, copy) void (^jumpBlock)(NSString *url, int type);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self blockAsMethodParameter:^(NSString *sigpause) {
        NSLog(@"call method with block parameter, method signature：%@", sigpause);
    }];
    
    [self _fileMoveAllToTrash];
    [self testPath];
}

- (void)testAutomaticParameter
{
    void (^autoBlock)(NSString *) = ^void(NSString *name) {
        NSLog(@"%@", name);
    };
    autoBlock(@"weng");
    
    int (^addBlock)(int , int) = ^(int addend, int summand) {
        return addend + summand;
    };
    int sum = addBlock(5, 3);
    NSLog(@"sum = %d", sum);
}

- (void)blockAsMethodParameter:(void (^)(NSString *signature))paraBlock
{
    NSLog(@"call method as para");
    SEL selector = @selector(blockAsMethodParameter:);
    NSString *signature = NSStringFromSelector(selector);
    paraBlock(signature);
}

- (void)_fileMoveAllToTrash {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    //将所有的data数据移动到trash 随机uuid路径下
    NSString *tmpPath = (__bridge NSString *)(uuid);
    NSLog(tmpPath);
    CFRelease(uuid);
}

- (void)testPath
{
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    
    NSString *filePath = [basePath stringByAppendingPathComponent:@"sqlite"];
    
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:filePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                             error:&error];
    
    NSArray *directoryContents = [manager contentsOfDirectoryAtPath:basePath error:NULL];
    NSLog(@"directoryContents: %@", directoryContents);
}

@end
