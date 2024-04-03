//
//  ViewController.m
//  BFOCClass分类
//
//  Created by 翁恒丛 on 2018/11/21.
//  Copyright © 2018年 LuCI. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "BFPerson.h"
#import "BFStudent.h"

@interface ViewController ()<UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testNSObject];
//    NSLog(@"----------------------");
    [self testBFPerson];
    [self testMethod];
}


/**
 测试方法调用
 */
- (void)testMethod
{
//    BFPerson *person = [[BFPerson alloc] init];
//    [person test];
    
    BFStudent *stu = [[BFStudent alloc] init];
//    [stu test];
//    ((void (*)(id, SEL))objc_msgSend)(stu, @selector(test));

//    [BFStudent test];
    Class stuClass = [BFStudent class];
    ((void (*)(id, SEL))objc_msgSend)(stuClass, @selector(test));
//    [BFPerson load];
//    [BFStudent load];
}

/*
 1.Class objc_getClass(const char *aClassName)
 1> 传入字符串类名
 2> 返回对应的类对象
 
 2.Class object_getClass(id obj)
 1> 传入的obj可能是instance对象、class对象、meta-class对象
 2> 返回值
 a) 如果是instance对象，返回class对象
 b) 如果是class对象，返回meta-class对象
 c) 如果是meta-class对象，返回NSObject（基类）的meta-class对象
 
 3.- (Class)class、+ (Class)class
 1> 返回的就是类对象
 
 - (Class) {
    return self->isa;
 }
 
 + (Class) {
    return self;
 }
 */
- (void)testNSObject
{
    // instance对象，实例对象
    NSObject *instance1 = [[NSObject alloc] init];
    NSObject *instance2 = [[NSObject alloc] init];
    
    // class对象，类对象
    // class方法返回的一直是class对象，类对象
    Class objectClass1 = [instance1 class];
    Class objectClass2 = [instance2 class];
    Class objectClass3 = object_getClass(instance1);
    Class objectClass4 = object_getClass(instance2);
    Class objectClass5 = [NSObject class];
    
    // meta-class对象，元类对象
    // 将类对象当做参数传入，获得元类对象
    Class objectMetaClass1 = object_getClass(objectClass5);
    Class objectMetaClass2 = [[[NSObject class] class] class];
    Class objectMetaClass3 = [[objectMetaClass1 class] class];
    BOOL result = class_isMetaClass([NSObject class]);
    NSLog(@"NSObject instance - %p %p",
          instance1,
          instance2);
    
    NSLog(@"NSObject class - %p %p %p %p %p %d",
          objectClass1,
          objectClass2,
          objectClass3,
          objectClass4,
          objectClass5,
          class_isMetaClass(objectClass3));
    
    NSLog(@"NSObject meta class - %p %d \n %p %d \n %p %d",
          objectMetaClass1,
          class_isMetaClass(objectMetaClass1),
          objectMetaClass2,
          class_isMetaClass(objectMetaClass2),
          objectMetaClass3,
          class_isMetaClass(objectMetaClass3)
          );
}

- (void)testBFPerson
{
    // instance对象，实例对象
    BFPerson *person1 = [[BFPerson alloc] init];
    person1.age = 20;
    person1.name = @"xu";
    
    BFPerson *person2 = [[BFPerson alloc] init];
    person2.age = 25;
    person2.name = @"weng";
    NSLog(@"BFPerson instance - %p %p",
          person1,
          person2);
    
    // class对象，类对象
    // class方法返回的一直是class对象，类对象
    Class personClass1 = [person1 class];
    Class personClass2 = [person2 class];
    Class personClass3 = object_getClass(person1);
    Class personClass4 = object_getClass(person2);
    Class personClass5 = [BFPerson class];
    NSLog(@"BFPerson class - %p %p %p %p %p %d",
          personClass1,
          personClass2,
          personClass3,
          personClass4,
          personClass5,
          class_isMetaClass(personClass3));
    
    // meta-class对象，元类对象
    // 将类对象当做参数传入，获得元类对象
    Class personMetaClass1 = object_getClass(personClass5);
    Class personMetaClass2 = [[[BFPerson class] class] class];
    NSLog(@"BFPerson meta class - %p %d %p %d",
          personMetaClass1,
          class_isMetaClass(personMetaClass1),
          personMetaClass2,
          class_isMetaClass(personMetaClass2));
    NSLog(@"================================");
}


@end
