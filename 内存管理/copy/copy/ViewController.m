//
//  ViewController.m
//  copy
//
//  Created by WengHengcong on 2019/1/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()

@end



/*
 
 拷贝的目的：产生一个副本对象，跟源对象互不影响
   1.修改了源对象，不会影响副本对象
   2.修改了副本对象，不会影响源对象
 
 iOS提供了2个拷贝方法
   1.copy，不可变拷贝，产生不可变副本
   2.mutableCopy，可变拷贝，产生可变副本
 
 深拷贝和浅拷贝
   1.深拷贝：内容拷贝，产生新的对象
   2.浅拷贝：指针拷贝，没有产生新的对象
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self dataTypeCopy];
//    [self objectCopy];
//    [self copyProperty];
//    [self stringCopy];
//    [self mutableStringCopy];
//    [self arrayCopy];
//    [self mutableArrayCopy];
    [self deepCopy];
    [self deepCopy2];
}

- (void)dataTypeCopy
{
    int a = 10;
    int b = a;
    NSLog(@"%p %p", &a, &b);
}

- (void)objectCopy
{
    BFPerson *tom = [[BFPerson alloc] init];
    tom.name = @"tom";
    tom.age = 10;
    
    BFPerson *jack = [tom copy];
    jack.name = @"jack";
    
    BFPerson *lily = [tom mutableCopy];
    
    NSLog(@"tom: %@, jack: %@", tom, jack);
}

- (void)copyProperty
{
    BFPerson *tom = [[BFPerson alloc] init];
    tom.name = @"tom";
    tom.age = 10;
    tom.data = [NSMutableArray array];
    //崩溃： -[__NSArray0 addObject:]: unrecognized selector sent to instance 0x1c4010960
    //@property (nonatomic, copy) NSMutableArray *data;
    //因为BFPerson类定义的是copy属性
    [tom.data addObject: @"a"];
}

- (void)stringCopy
{
    NSString *str1 = [NSString stringWithFormat:@"123"];
    NSString *str2 = [str1 copy];                     //浅拷贝
    NSMutableString *str3 = [str1 mutableCopy];       //深拷贝
    
    //0xa000000003332313, 0xa000000003332313, 0x1c00524e0
    NSLog(@"%p, %p, %p", str1, str2, str3);
    //-1, -1, 1
    NSLog(@"retainCount: %lu, %lu, %lu ",
          [str1 retainCount],
          [str2 retainCount],
          [str3 retainCount]);
    
    [str1 release];
    [str2 release];
    [str3 release];
}

- (void)mutableStringCopy
{
    NSMutableString *str1 = [NSMutableString stringWithString:@"123"];
    NSString *str2 = [str1 copy];                     //深拷贝
    NSMutableString *str3 = [str1 mutableCopy];       //深拷贝
    
    //0x1c0052240, 0xa000000003332313, 0x1c0051700
    NSLog(@"%p, %p, %p", str1, str2, str3);
    // 1, -1, 1
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [str1 retainCount],
          [str2 retainCount],
          [str3 retainCount]);
    [str1 release];
    [str2 release];
    [str3 release];
}

- (void)arrayCopy
{
    //copy返回不可变对象，mutablecopy返回可变对象
    //浅拷贝：arr2是和arr1同一个对象，其内部元素浅拷贝
    //深拷贝：arr3是arr1的可变副本，指向不同的对象，其内部元素浅拷贝
    NSArray *arr1 = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
    NSArray *arr2 = [arr1 copy];
    NSMutableArray *arr3 = [arr1 mutableCopy];
    //0x1c00514c0, 0x1c00514c0, 0x1c0052600
    NSLog(@"%p, %p, %p", arr1, arr2, arr3);
    //2, 2, 1
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [arr1 retainCount],
          [arr2 retainCount],
          [arr3 retainCount]);
    
    //arr[0]: 0x1c00525a0, 0x1c00525a0, 0x1c00525a0     //浅拷贝
    NSLog(@"arr[0]: %p, %p, %p", arr1[0], arr2[0], arr3[0]);
    //arr[0] retainCount: 3, 3, 3
    NSLog(@"arr[0] retainCount: %ld, %ld, %ld ",
          [arr1[0] retainCount],
          [arr2[0] retainCount],
          [arr3[0] retainCount]);
    
    [arr1 release];
    [arr2 release];
}

- (void)mutableArrayCopy
{
    //copy返回不可变对象，mutablecopy返回可变对象
    //深拷贝：arr2是和arr1是不同对象，其内部元素是浅拷贝
    //深拷贝：arr3也是和arr1不同对象，其内部元素是浅拷贝
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c", nil];
    NSArray *arr2 = [arr1 copy];
    NSMutableArray *arr3 = [arr1 mutableCopy];
    //0x1c00524b0, 0x1c0052420, 0x1c00522a0
    NSLog(@"%p, %p, %p", arr1, arr2, arr3);
    //1, 1, 1
    NSLog(@"retainCount: %ld, %ld, %ld ",
          [arr1 retainCount],
          [arr2 retainCount],
          [arr3 retainCount]);
    //arr[0]: 0x1c0052540, 0x1c0052540, 0x1c0052540
    NSLog(@"arr[0]: %p, %p, %p", arr1[0], arr2[0], arr3[0]);
    //arr[0] retainCount: 3, 3, 3
    NSLog(@"arr[0] retainCount: %ld, %ld, %ld ",
          [arr1[0] retainCount],
          [arr2[0] retainCount],
          [arr3[0] retainCount]);
    
    [arr1 release];
    [arr2 release];
}


/**
 容器对象的元素深拷贝
 */
- (void)deepCopy
{
    /*
     深拷贝
     对于array最顶层的调用copyWithZone
     [[NSDictionary alloc] initWithDictionary:[NSDictionary dictionary] copyItems:YES];
    */
    NSLog(@"deepCopy");
    BFPerson *person = [[BFPerson alloc] init];
    NSMutableArray *strArr = [NSMutableArray arrayWithObjects:@"a", nil];
    NSArray *arr1 = [NSArray arrayWithObjects:strArr,
                     [NSMutableString stringWithString:@"b"],person,@"c", nil];
    NSArray *arr2 = [[NSArray alloc] initWithArray:arr1 copyItems:YES];

    NSLog(@"class: %@ %@ %@ %@ %@ %@ %@ %@",
          [arr1[0] class], [arr1[1] class], [arr1[2] class],[arr1[3] class],
          [arr2[0] class], [arr2[1] class],[arr2[2] class], [arr2[3] class]);

    NSLog(@"arr1: %p [0]: %p, [1]: %p, [2]: %p", arr1, arr1[0], arr1[1], arr2[2]);
    NSLog(@"arr2: %p [0]: %p, [1]: %p, [2]: %p", arr2, arr2[0], arr2[1], arr2[2]);

    NSLog(@"arr1 count: %ld, [0]: %ld, [1]: %ld, [2]: %ld",
          [arr1 retainCount],
          [arr1[0] retainCount],
          [arr1[1] retainCount],
          [arr1[2] retainCount]);
    NSLog(@"arr2 count: %ld, [0]: %ld, [1]: %ld, [2]: %ld",
          [arr2 retainCount],
          [arr2[0] retainCount],
          [arr2[1] retainCount],
          [arr1[2] retainCount]);
    
    [arr1 release];
    [arr2 release];
}

/**
 容器对象的元素深拷贝
 */
- (void)deepCopy2
{
    /*
      全面深拷贝
      1. 常量元素也会深拷贝，并且以适当的方式存储，比如第3个元素@"b"，就会以Tagged Pointer存储
      2. 对象元素会进行深拷贝
      */
    NSLog(@"deepCopy2");
    BFPerson *person = [[BFPerson alloc] init];
    NSArray *arr1 = [NSArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"a", nil],
                     [NSMutableString stringWithString:@"b"],person, @"c",nil];
    NSArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject:arr1]];
   
    NSLog(@"class: %@ %@ %@ %@ %@ %@ %@ %@",
          [arr1[0] class], [arr1[1] class], [arr1[2] class],[arr1[3] class],
          [arr2[0] class], [arr2[1] class],[arr2[2] class], [arr2[3] class]);
    
    NSLog(@"arr1: %p [0]: %p, [1]: %p, [2]: %p", arr1, arr1[0], arr1[1], arr2[2]);
    NSLog(@"arr2: %p [0]: %p, [1]: %p, [2]: %p", arr2, arr2[0], arr2[1], arr2[2]);
    
    NSLog(@"arr1 count: %ld, [0]: %ld, [1]: %ld, [2]: %ld",
          [arr1 retainCount],
          [arr1[0] retainCount],
          [arr1[1] retainCount],
          [arr1[2] retainCount]);
    NSLog(@"arr2 count: %ld, [0]: %ld, [1]: %ld, [2]: %ld",
          [arr2 retainCount],
          [arr2[0] retainCount],
          [arr2[1] retainCount],
          [arr1[2] retainCount]);
    
    [arr1 release];
    [arr2 release];
}

@end
