//
//  ViewController.m
//  TaggedPointer
//
//  Created by WengHengcong on 2019/1/3.
//  Copyright © 2019 WengHengcong. All rights reserved.
//


#import "ViewController.h"

#if TARGET_OS_OSX && __x86_64__
#   define OBJC_MSB_TAGGED_POINTERS 0
#else
#   define OBJC_MSB_TAGGED_POINTERS 1
#endif

#if OBJC_MSB_TAGGED_POINTERS
#   define _OBJC_TAG_MASK (1UL<<63)
#else
#   define _OBJC_TAG_MASK 1UL
#endif

BOOL isTaggedPointer(id pointer)
{
    return ((long)(__bridge void *)pointer & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
}

@interface ViewController ()
@property (strong, nonatomic) NSString *name;
@end

@implementation ViewController

//- (void)setName:(NSString *)name
//{
//    if (_name != name) {
//        [_name release];
//        _name = [name retain];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self taggedPointerMemory];
//    [self taggedPointer];
//    [self stringType];
    [self testTaggedPointer];
}

- (void)stringType
{
    //__NSCFConstantString -> __NSCFString -> NSMutableString -> NSString -> NSObject
    NSString *str1 = @"123";
    NSString *str2 = [NSString stringWithFormat:@"123"];
    NSString *str3 = [NSString stringWithFormat:@"123123123123123123123123123123"];
    NSMutableString *str4 = [NSMutableString stringWithFormat:@"123"];
    // __NSCFConstantString NSTaggedPointerString __NSCFString __NSCFString
    NSLog(@"%@ %@ %@ %@", [str1 class], [str2 class], [str3 class], [str4 class]);
}

/**
  Tagged Pointer 内存管理
 1.  Tagged Pointer本质上不是对象
 */
- (void)taggedPointerMemory
{
    __weak NSNumber *weakNumber;
    __weak NSString *weakString;
    __weak NSDate *weakDate;
    __weak NSObject *weakObj;
    int num = 123;
    
    @autoreleasepool {
        weakObj = [[NSObject alloc] init];
        weakNumber = [NSNumber numberWithInt:num];
        weakString = [NSString stringWithFormat:@"string%d", num];
        weakDate   = [NSDate dateWithTimeIntervalSince1970:0];
    }
    NSLog(@"weakObj is %@", weakObj);
    NSLog(@"weakNumber is %@", weakNumber);
    NSLog(@"weakString is %@", weakString);
    NSLog(@"weakDate is %@", weakDate);
    
    // 以下代码需要在MRC下执行，需要在设置里进行设置
//    NSLog(@"%lu", [weakObj retainCount]);
//    NSLog(@"%lu", [weakNumber retainCount]);        //2^63-1
}


/**
 Tagged Pointer测试
 */
- (void)taggedPointer
{
    /*
     1. NSNumber *number = [NSNumber numberWithInt:10]; 与 NSNumber *number = @(10);、NSNumber *number1 = @1; 本质是相同的，为语法糖
     2. NSNumber类型：最高4位的“b”表示是NSNumber类型，最低4位(Int为2，long为3，float为4，double为5）表示基本数据类型，其余56位则用来存储数值本身内容。存储用的数值超过56位存储上限的时候，那么NSNumber才会用真正的64位内存地址存储数值，然后用指针指向该内存地址
     */
    NSNumber *number1 = @1;                          //0xb000000000000012
    NSNumber *number2 = @2;                          //0xb000000000000022
    NSNumber *number3 = @(0xFFFFFFFFFFFFFFF);        //0x1c0022560
    NSNumber *number4 = @(1.2);                      //0x1c0024b80

    int num4 = 5;
    NSNumber *number5 = @(num4);                     //0xb000000000000052
    long num5 = 6;
    NSNumber *number6 = @(num5);                     //0xb000000000000063
    float num6 = 7;
    NSNumber *number7 = @(num6);                     //0xb000000000000074
    double num7 = 8;
    NSNumber *number8 = @(num7);                     //0xb000000000000085
    
    NSLog(@"%d %d %d %d",
          isTaggedPointer(number1),  //1
          isTaggedPointer(number2),  //1
          isTaggedPointer(number3),  //0
          isTaggedPointer(number4)); //0
    NSLog(@"%@ %@ %@ %@",
          [number1 class],  //__NSCFNumber
          [number2 class],  //__NSCFNumber
          [number3 class],  //__NSCFNumber
          [number3 class]); //__NSCFNumber

    //打印地址：0x16da11318 0x16da11310 0x16da11308 0x16da11300 0x16da112f0 0x16da112e0 0x16da112d0 0x16da112c0
    NSLog(@"%p %p %p %p %p %p %p %p", &number1, &number2, &number3, &number4, &number5, &number6, &number7, &number8);
    
    //打印该地址存储的值：0xb000000000000012 0xb000000000000022 0x1c0022560 0x1c0024b80 0xb000000000000052 0xb000000000000063 0xb000000000000074 0xb000000000000085
    NSLog(@"%p %p %p %p %p %p %p %p", number1, number2, number3, number4, number5, number6, number7, number8);
    
    /*
     NSString类型：最高位表示类型，最低位表示字符串长度。而其余的56位也是用来存储数据内容。
     NSString类型：当字符串内存长度超过了56位的时候，Tagged Pointer并没有立即用指针转向，而是用了一种算法编码，把字符串长度进行压缩存储，当这个算法压缩的数据长度超过56位了才使用指针指向。
     NSString类型：当String的内容有中文或者特殊字符（非 ASCII 字符）时，那么就只能存储为String指针。
     NSString类型：字面型字符串常量却从不存储为Tagged Pointer，因为字符串常量必须在不同的操作系统版本下保持二进制兼容，而Tagged Pointer在运行时总是由Apple的代码生成。
     */
    NSString *str1 = @"a";                                          //0x1049cc248
    NSString *str2 = [NSString stringWithFormat:@"a"];              //0xa000000000000611
    NSString *str3 = [NSString stringWithFormat:@"bccd"];           //0xa000000646363624
    NSString *str4 = [NSString stringWithFormat:@"c"];              //0xa000000000000631
    NSString *str5 = [NSString stringWithFormat:@"cdasjkfsdljfiwejdsjdlajfl"];  //0x1c02418f0
    NSLog(@"%d %d %d %d %d",
          isTaggedPointer(str1),
          isTaggedPointer(str2),
          isTaggedPointer(str3),
          isTaggedPointer(str4),
          isTaggedPointer(str5)); // 0 1 1 1 0
    NSLog(@"%@ %@ %@ %@ %@",
          [str1 class],   //__NSCFConstantString
          [str2 class],   //NSTaggedPointerString
          [str3 class],   //NSTaggedPointerString
          [str4 class],   //NSTaggedPointerString
          [str5 class]);  // __NSCFString
    
    //0x16b4392b8 0x16b4392b0 0x16b4392a8 0x16b4392a0 0x16b439298
    NSLog(@"%p %p %p %p %p", &str1, &str2, &str3, &str4, &str5);
    NSLog(@"%p %p %p %p %p",
          str1,     //0x10043c248
          str2,     //0xa 00000000000061 1
          str3,     //0xa 00000064636362 4
          str4,     //0xa 00000000000063 1
          str5);    //0x1c045bf90
}

- (void)testTaggedPointer
{
    // 下面代码会崩溃，会有多个线程去访问setter，可能导致多次release
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLock *lock = [[NSLock alloc] init];
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            // 加锁
//            [lock lock];
            self.name = [NSString stringWithFormat:@"abcdefghijk"];
            // 解锁
//            [lock unlock];
        });
    }
    
    // 代码正常运行，是因为运用了Tagged Pointer技术，访问的是栈中地址，而不是一个对象，所以不会调用setter方法
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);

    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue1, ^{
            self.name = [NSString stringWithFormat:@"abc"];
        });
    }
    
    NSString *str1 = [NSString stringWithFormat:@"abcdefghijk"];
    NSString *str2 = [NSString stringWithFormat:@"123abc"];
    
    NSLog(@"%@ %@", [str1 class], [str2 class]);
    NSLog(@"%p", str2);
}

@end
