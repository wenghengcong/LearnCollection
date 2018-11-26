//
//  ViewController.m
//  KVO
//
//  Created by WengHengcong on 2018/11/25.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
#import "ObserverPersonChage.h"

@interface ViewController ()

@property (nonatomic, strong) BFPerson *person1;
@property (nonatomic, strong) BFPerson *person2;

@property (nonatomic, strong) ObserverPersonChage *observerPersonChange;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.person1 = [[BFPerson alloc] init];
    self.person1.age = 28;
    self.person1.name = @"weng";
    
    self.person2 = [[BFPerson alloc] init];
    self.person2.age = 26;
    self.person2.name = @"xu";
    
    self.observerPersonChange = [[ObserverPersonChage alloc] init];

    [self addObserver];
}

/**
 注册观察者
 */
- (void)addObserver
{
    NSKeyValueObservingOptions option = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
    
    [self.person1 addObserver:self forKeyPath:@"age" options:option context:@"age chage"];
    [self.person1 addObserver:self forKeyPath:@"name" options:option context:@"name change"];

//    [self.person1 addObserver:self.observerPersonChange forKeyPath:@"age" options:option context:@"age chage"];
//    [self.person1 addObserver:self.observerPersonChange forKeyPath:@"name" options:option context:@"name change"];
}

/**
 触发KVO
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person1.age = 29;
    self.person1.name = @"hengcong";
    
    self.person2.age = 27;
    self.person2.name = @"qiuqiu";
}

/**
 观察者监听的回调方法

 @param keyPath 监听的keyPath
 @param object 监听的对象
 @param change 更改的字段内容
 @param context 注册时传入的地址值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%s---监听到%@的%@属性值改变了 - %@ - %@", __func__, object, keyPath, change, context);
}

/**
 移除观察者的时机
 */
- (void)dealloc
{
//    [self removeObserver];
}

- (IBAction)clearObserverPersonChange:(id)sender {
    self.observerPersonChange = nil;
}

/**
 移除观察者
 */
- (void)removeObserver
{
    [self.person1 removeObserver:self forKeyPath:@"age"];
    [self.person1 removeObserver:self forKeyPath:@"name"];
}

@end
