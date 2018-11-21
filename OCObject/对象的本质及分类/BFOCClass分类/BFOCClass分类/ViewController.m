//
//  ViewController.m
//  BFOCClass分类
//
//  Created by 翁恒丛 on 2018/11/21.
//  Copyright © 2018年 LuCI. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "BFPerson.h"
#import "BFBoy.h"
#import "BFGirl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testNSObject];
    NSLog(@"----------------------");
    [self testBFPerson];
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
    
    NSLog(@"NSObject meta class - %p %d \n %p %d",
          objectMetaClass1,
          class_isMetaClass(objectMetaClass1),
          objectMetaClass2,
          class_isMetaClass(objectMetaClass2));
}

- (void)testBFPerson
{
    // instance对象，实例对象
    BFPerson *person1 = [[BFPerson alloc] init];
    BFPerson *person2 = [[BFPerson alloc] init];
    
    // class对象，类对象
    // class方法返回的一直是class对象，类对象
    Class personClass1 = [person1 class];
    Class personClass2 = [person2 class];
    Class personClass3 = object_getClass(person1);
    Class personClass4 = object_getClass(person2);
    Class personClass5 = [BFPerson class];
    
    // meta-class对象，元类对象
    // 将类对象当做参数传入，获得元类对象
    Class personMetaClass1 = object_getClass(personClass5);
    Class personMetaClass2 = [[[BFPerson class] class] class];
    
    NSLog(@"BFPerson instance - %p %p",
          person1,
          person2);
    
    NSLog(@"BFPerson class - %p %p %p %p %p %d",
          personClass1,
          personClass2,
          personClass3,
          personClass4,
          personClass5,
          class_isMetaClass(personClass3));
    
    NSLog(@"BFPerson meta class - %p %d \n %p %d",
          personMetaClass1,
          class_isMetaClass(personMetaClass1),
          personMetaClass2,
          class_isMetaClass(personMetaClass2));
}


@end
