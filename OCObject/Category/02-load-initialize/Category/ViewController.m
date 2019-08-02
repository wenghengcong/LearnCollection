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
#import "BFBoy.h"
#import "BFBoy+Tall.h"
#import "BFBoy+Handsome.h"
#import "BFGirl.h"
#import "BFGirl+Rich.h"
#import "BFGirl+Beauty.h"

@interface ViewController ()

@property (nonatomic, strong)BFPerson *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [BFBoy alloc];
    [BFGirl alloc];
//    [BFPerson alloc];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BFPerson *person = [[BFPerson alloc] init];
    [person test];
}

@end
