//
//  ViewController.m
//  TestPerformance
//
//  Created by WengHengcong on 2017/11/22.
//  Copyright © 2017年 LuCi. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface YYMessage : NSObject
@property (nonatomic, assign) uint64_t messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic ,copy)   NSString *name;
@end

@implementation YYMessage

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testCoreFoundationSetter];
    
    //NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSMutableArray *array = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend) ( (id)[NSMutableArray class], @selector(alloc) );
//    array = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(init));
    
    NSMutableArray* (*arrayAllocMsg) (id, SEL) = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend);
    NSMutableArray *array = arrayAllocMsg((id)[NSMutableArray class], @selector(alloc));
    
    NSMutableArray* (*arrayInitMsg) (id, SEL) = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend);
    array = arrayInitMsg( (id)array, @selector(init));
    
    //[array addObject:@"dog"];
    ( (void (*) (id, SEL, NSString *)) objc_msgSend) ( (id)array, @selector(addObject:), @"dog");
    
    //NSInteger index = [array indexOfObject:@"dog"];
    NSInteger index = ( (NSInteger (*) (id, SEL, NSString *)) objc_msgSend) ( (id)array, @selector(indexOfObject:), @"dog");
    
    //NSString *last = [array lastObject];
    NSString *last = ( (NSString * (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(lastObject));
    
    //[array removeLastObject];
    ( (void (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(removeLastObject));
    
}


- (void)testCoreFoundationMemoryManagement
{
    NSString *aNSString = [[NSString alloc]initWithFormat:@"test"];
    CFStringRef aCFString = (__bridge_retained CFStringRef) aNSString;
}

- (void)testCoreFoundationSetter
{
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    NSLog(@"KVC设置前");
    for (int i = 0; i < 100000000; i++) {
        [dic1 setValue:@"haha" forKey:@"name"];
    }
    NSLog(@"KVC设置后");
    
    CFMutableDictionaryRef dic2 = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    NSLog(@"--------------------");
    
    NSLog(@"CF设置前");
    for (int i = 0; i < 100000000; i++) {
        CFDictionarySetValue(dic2, (__bridge const void *)(@"name"), (__bridge const void *)(@"haha"));
    }
    NSLog(@"CF设置后");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}


@end
