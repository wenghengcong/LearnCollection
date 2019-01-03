//
//  ViewController.m
//  copy
//
//  Created by WengHengcong on 2019/1/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)stringCopy
{
    NSString *str1 = [NSString stringWithFormat:@"123"];
    NSString *str2 = [str1 copy];                     //浅拷贝，str:123 ,cpstr:123
    NSMutableString *str3 = [str1 mutableCopy];       //深拷贝，str:1 ,cpstr:15

    NSLog(@"%p, %p, %p", str1, str2, str3);
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [str1 retainCount],
          [str2 retainCount],
          [str3 retainCount]);
}

- (void)mutableStringCopy
{
    NSMutableString *str1 = [NSMutableString stringWithString:@"123"];
    NSString *str2 = [str1 copy];                     //浅拷贝，str:123 ,cpstr:123
    NSMutableString *str3 = [str1 mutableCopy];       //深拷贝，str:1 ,cpstr:15
    
    NSLog(@"%p, %p, %p", str1, str2, str3);
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [str1 retainCount],
          [str2 retainCount],
          [str3 retainCount]);
}

- (void)arrayCopy
{
    //copy返回不可变对象，mutablecopy返回可变对象
    NSArray *arr1 = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
    NSArray *arr2 = [arr1 copy];
    NSMutableArray *arr3 = [arr1 mutableCopy];
    
    NSLog(@"%p, %p, %p", arr1, arr2, arr3);
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [arr1 retainCount],
          [arr2 retainCount],
          [arr3 retainCount]);
    
    NSLog(@"arr[0]: %p, %p, %p", arr1[0], arr2[0], arr3[0]);
    NSLog(@"arr[0] retainCount: %ld, %ld, %ld ",
          [arr1[0] retainCount],
          [arr2[0] retainCount],
          [arr3[0] retainCount]);
    
    //arrayCopy1是和array同一个NSArray对象（指向相同的对象），包括array里面的元素也是指向相同的指针

    //mArrayCopy是array的可变副本，指向的对象和array不同，但是其中的元素和array1中的元素指向的是同一个对象。mArrayCopy还可以修改自己的对象
}

- (void)mutableArrayCopy
{
    //copy返回不可变对象，mutablecopy返回可变对象
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c", nil];
    NSArray *arr2 = [arr1 copy];
    NSMutableArray *arr3 = [arr1 mutableCopy];
    
    NSLog(@"%p, %p, %p", arr1, arr2, arr3);
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [arr1 retainCount],
          [arr2 retainCount],
          [arr3 retainCount]);
    
    NSLog(@"arr[0]: %p, %p, %p", arr1[0], arr2[0], arr3[0]);
    NSLog(@"arr[0] retainCount: %ld, %ld, %ld ",
          [arr1[0] retainCount],
          [arr2[0] retainCount],
          [arr3[0] retainCount]);
    
    //arrayCopy1是和array同一个NSArray对象（指向相同的对象），包括array里面的元素也是指向相同的指针
    
    //mArrayCopy是array的可变副本，指向的对象和array不同，但是其中的元素和array1中的元素指向的是同一个对象。mArrayCopy还可以修改自己的对象
}

@end
