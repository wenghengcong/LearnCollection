//
//  ViewController.m
//  SuperChildSameResponder
//
//  Created by Nemo on 2024/9/6.
//

#import "ViewController.h"
#import "SuperView.h"
#import "SuperView2.h"
#import "ChildView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SuperView *superView = [[SuperView alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
    superView.userInteractionEnabled = YES;
    superView.backgroundColor = [UIColor redColor];
    [self.view addSubview: superView];
    
    ChildView *childView = [[ChildView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    childView.userInteractionEnabled = YES;
    childView.backgroundColor = [UIColor blueColor];
    [superView addSubview: childView];
    
    
    SuperView2 *superView2 = [[SuperView2 alloc] initWithFrame:CGRectMake(10, 400, 200, 200)];
    superView2.userInteractionEnabled = YES;
    superView2.backgroundColor = [UIColor greenColor];
    [self.view addSubview: superView2];
    
    ChildView *childView2 = [[ChildView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    childView2.userInteractionEnabled = YES;
    childView2.backgroundColor = [UIColor blueColor];
    [superView2 addSubview: childView2];
}

@end
