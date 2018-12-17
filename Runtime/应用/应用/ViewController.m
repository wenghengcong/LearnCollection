//
//  ViewController.m
//  应用
//
//  Created by WengHengcong on 2018/12/17.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "BFPerson.h"
#import "NSObject+JSON.h"

@interface ViewController ()

@end

@implementation ViewController

void replaceEat()
{
    NSLog(@"not eat");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*--------------查看私有变量----------------*/
    [self viewTextFieldIvar];
    
    /*--------------字典转模型----------------*/
    NSDictionary *json = @{
                           @"id" : @10000,
                           @"age" : @28,
                           @"name" : @"weng"
                           };
    BFPerson *person = [BFPerson bf_objectWithJson:json];
    NSLog(@"person %@", person);
    
    /*--------------方法交换/替换----------------*/
    Method runMethod = class_getInstanceMethod([BFPerson class], @selector(run));
    Method eatMethod = class_getInstanceMethod([BFPerson class], @selector(eat));
    method_exchangeImplementations(runMethod, eatMethod);
    
    [person run];
    
    class_replaceMethod([BFPerson class], @selector(eat), (IMP)replaceEat, "v");
    [person eat];

    class_replaceMethod([BFPerson class], @selector(learn), imp_implementationWithBlock(^{
        NSLog(@"not learn, playing now");
    }), "v");
    [person learn];
    
    /*--------------动态创建类/动态设置类----------------*/
    createClass();
    id car = [[Car alloc] init];
    [car performSelector:@selector(setWheels:) withObject:@4];
    NSLog(@"%@", [car performSelector:@selector(wheels)]);
    
    testIvars();
}


- (void)viewTextFieldIvar
{
    /*
     unsigned int count;
     Ivar *ivars = class_copyIvarList([UITextField class], &count);
     for (int i = 0; i < count; i++) {
     // 取出i位置的成员变量
     Ivar ivar = ivars[i];
     NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
     }
     free(ivars);
     */
    self.textField.placeholder = @"请输入用户名";
    [self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UILabel *placeholderLabel = [self.textField valueForKeyPath:@"_placeholderLabel"];
    placeholderLabel.textColor = [UIColor redColor];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor redColor];
    self.textField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入用户名" attributes:attrs];
}

Class Car;
NSNumber *wheelsGetter(id self, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable(Car, "_wheels");
    return object_getIvar(self, ivar);
}

void wheelsSetter(id self, SEL _cmd, NSNumber* newCount) {
    Ivar ivar = class_getInstanceVariable(Car, "_wheels");
    id oldCount = object_getIvar(self, ivar);
    if (oldCount != newCount) object_setIvar(self, ivar, [newCount copy]);
}

void createClass() {
    // allocate class
    Car =  objc_allocateClassPair([NSObject class], "Car", 0);
    
    // add iVar
    class_addIvar(Car, "_wheels", sizeof(NSNumber*), log2(sizeof(NSNumber*)), @encode(NSNumber*));
    
    // add property
    objc_property_attribute_t type = { "T", "@\"NSNumber\"" };
    objc_property_attribute_t backingivar  = { "V", "_wheels" };
    objc_property_attribute_t attrs[] = { type, backingivar };
    class_addProperty(Car, "wheels", attrs, 2);
    
    // add getter method
    class_addMethod(Car, @selector(wheels), (IMP)wheelsGetter, "@@:");
    
    // add setter method
    class_addMethod(Car, @selector(setWheels:), (IMP)wheelsSetter, "v@:@");
    
    // register class
    objc_registerClassPair(Car);
}


void testIvars()
{
    // 获取成员变量信息
    Ivar ageIvar = class_getInstanceVariable([BFPerson class], "_age");
    NSLog(@"%s %s", ivar_getName(ageIvar), ivar_getTypeEncoding(ageIvar));
    
    // 设置和获取成员变量的值
    Ivar nameIvar = class_getInstanceVariable([BFPerson class], "_name");
    Ivar IdIvar = class_getInstanceVariable([BFPerson class], "_ID");
    
    BFPerson *person = [[BFPerson alloc] init];
    object_setIvar(person, ageIvar,  (__bridge id _Nullable)((void*)28));
    object_setIvar(person, IdIvar,  (__bridge id _Nullable)((void*)10000));
    //为什么nameIvar一定要放到最后一行，前面两个变量无顺序
    object_setIvar(person, nameIvar, @"wenghengcong");
    NSLog(@"%d, %@ %d",person.ID, person.name, person.age);
}

@end
