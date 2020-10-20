//
//  ViewController.m
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Student *s = [[Student alloc] init];
    [s sayHello];
}


@end
