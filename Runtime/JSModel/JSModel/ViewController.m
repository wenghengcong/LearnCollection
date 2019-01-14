//
//  ViewController.m
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "JSPerson.h"
#import "NSObject+JSModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *dic = @{
                          @"name":@"wenghengcong",
                          @"age":@"25",
                          @"height":@"170",
                          @"sex":@"true",
                          @"dog":@{
                                  @"nickName":@"John",
                                  @"furColor":@"blue"
                                  },
                          @"books":@[
                                  @{@"title":@"Book1",@"price":@"1.0"},
                                  @{@"title":@"Book2",@"price":@"4.0"}
                                  ]
                          };
    JSPerson *person = [JSPerson modelWithDic:dic];
    JSDog *dog = person.dog;
    JSBook *book = person.books[0];
    NSLog(@"%@",person);
    NSLog(@"%@ %@",dog.nickName ,dog.furColor);
    NSLog(@"%@ %d",book.title,book.price);

//    [self printEncode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printEncode {
    
    NSLog(@"int        : %s", @encode(int));
    NSLog(@"float      : %s", @encode(float));
    NSLog(@"float *    : %s", @encode(float*));
    NSLog(@"char       : %s", @encode(char));
    NSLog(@"char *     : %s", @encode(char *));
    NSLog(@"BOOL       : %s", @encode(BOOL));
    NSLog(@"void       : %s", @encode(void));
    NSLog(@"void *     : %s", @encode(void *));
    
    NSLog(@"NSObject * : %s", @encode(NSObject *));
    NSLog(@"NSObject   : %s", @encode(NSObject));
    NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class])));
    NSLog(@"NSError ** : %s", @encode(typeof(NSError **)));
    
    NSLog(@"id    : %s", @encode(id));

    int intArray[5] = {1, 2, 3, 4, 5};
    NSLog(@"int[]      : %s", @encode(typeof(intArray)));
    
    float floatArray[3] = {0.1f, 0.2f, 0.3f};
    NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
    
    typedef struct _struct {
        short a;
        long long b;
        unsigned long long c;
    } Struct;
    NSLog(@"struct     : %s", @encode(typeof(Struct)));

}

@end
