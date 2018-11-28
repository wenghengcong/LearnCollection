//
//  ViewController.m
//  Category
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
#import "BFPerson+Study.h"
#import "BFPerson+Work.h"

@interface ViewController ()

@property (nonatomic, strong)BFPerson *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.person = [[BFPerson alloc] init];
    self.person.age = 28;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
