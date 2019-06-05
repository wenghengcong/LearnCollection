//
//  ViewController.m
//  Block类型与copy
//
//  Created by WengHengcong on 2018/12/7.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "BFPerson.h"

@interface ViewController ()
@property(nonatomic, strong) BFPerson *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.person = [[BFPerson alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.person testCopy];
//    [self.person testBlockWithStrong];
//    [self.person testStackBlockInMRC];
    [self testBlockType];
//    [self testMemory];
}
/* ----------------------------------*/
int good = 1;
void (^globalBlock1)(void) = ^{
    NSLog(@"%d", good);
    NSLog(@"globalBlock1->ARC:__NSGlobalBlock__  MRC:__NSGlobalBlock__");
};

- (void)testBlockType
{
    void (^globalBlock2)(void) = ^{
        NSLog(@"globalBlock2->ARC:__NSGlobalBlock__  MRC:__NSGlobalBlock__ %d");
    };
    
    // 注意：MRC下是__NSStackBlock，在ARC下会自动copy到堆，成为__NSMallocBlock
    int age = 10;
    void (^stackBlock1)(void) = ^{
        NSLog(@"stackBlock1->ARC:__NSMallocBlock  MRC:__NSStackBlock");
        NSLog(@"%d", age);
    };

    // 注意：^{ NSLog(@"temp block-> ARC:__NSStackBlock  MRC:__NSStackBlock"); NSLog(@"%d", age) } 为自动变量
    // 在此处为测试ARC情况下的Stack Block
    NSLog(@"class: %@ %@ %@ %@",[globalBlock1 class], [globalBlock2 class], [stackBlock1 class], [^{
        NSLog(@"stackBlock2-> ARC:__NSStackBlock  MRC:__NSStackBlock");
        NSLog(@"%d", age);
    } class]);
    
    NSLog(@"globalBlock1 superclass: %@--%@--%@",
          [[globalBlock1 class] superclass],
          [[[globalBlock1 class] superclass] superclass],
          [[[[globalBlock1 class] superclass] superclass] superclass]
          );
    
    NSLog(@"globalBlock2 superclass: %@--%@--%@",
          [[globalBlock2 class] superclass],
          [[[globalBlock2 class] superclass] superclass],
          [[[[globalBlock2 class] superclass] superclass] superclass]
          );
    
    NSLog(@"stackBlock1 superclass: %@--%@--%@",
          [[stackBlock1 class] superclass],
          [[[stackBlock1 class] superclass] superclass],
          [[[[stackBlock1 class] superclass] superclass] superclass]
          );
    
    NSLog(@"stackBlock2 superclass %@--%@--%@",
          [[^{NSLog(@"%d", age);} class] superclass],
          [[[[^{NSLog(@"%d", age);} class] class] superclass] superclass],
          [[[[^{NSLog(@"%d", age);} class] superclass] superclass] superclass]
          );
}

/* ----------------------------------*/
int age = 28;
- (void)testMemory
{
    int height = 170;
    NSLog(@"数据段：age %p", &age);
    NSLog(@"栈：height %p", &height);
    NSLog(@"堆：obj %p", [[NSObject alloc] init]);
    NSLog(@"数据段：class %p", [UIView class]);
}


@end
