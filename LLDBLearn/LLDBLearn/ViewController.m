//
//  ViewController.m
//  LLDBLearn
//
//  Created by 翁恒丛 on 2018/11/1.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"

@interface ViewController ()
{
    int _source;
}
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _source = 3;
    _data = [NSMutableArray arrayWithObjects:@"data_1", nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    NSLog(@"data : %@", _data);
    NSLog(@"source is %d", _source);
    
    BFPerson *person = [[BFPerson alloc] init];
    person.name = @"weng";
    person.age = 28;
    NSLog(@"name is %@, age is %lu", person.name, person.age);
}


@end
