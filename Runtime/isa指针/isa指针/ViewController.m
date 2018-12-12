//
//  ViewController.m
//  isa指针
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "BFPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //BFPerson 类地址：0x100d88e38 = 0x0000000ffffffff8 & ISA(0x000001a100d88e39 or 0x000001a100d88e3b....)
    //  0000 0000 0000 0000 0000 0000 0000 0001 1010 0001 0000 0000 1101 1000 1000 1110 0011 1001
    //& 0000 0000 0000 0000 0000 0000 0000 0000 0000 1111 1111 1111 1111 1111 1111 1111 1111 1000
    //--------------------------------------------------------------------------------------------
    //  0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 0000 0000 1101 1000 1000 1110 0011 1000
    NSLog(@"1----%p", [BFPerson class]);
    
    //https://www.binaryhexconverter.com/hex-to-binary-converter
    //0：nonpointer, 是否指针优化过，优化过即1，表示存储更多信息
    BFPerson *person1 = [[BFPerson alloc] init];
    //(0x000001a100d88e39) = (0000 0000 0000 0000 0000 0000 0000 0001 1010 0001 0000 0000 1101 1000 1000 1110 0011 1001)
    
    //1：has_assoc, 添加关联对象
    objc_setAssociatedObject(person1, @"test", @"good", OBJC_ASSOCIATION_RETAIN);
    //(0x000001a100d88e3b) = (0000 0000 0000 0000 0000 0000 0000 0001 1010 0001 0000 0000 1101 1000 1000 1110 0011 1011)
    
    //3-35: shiftclass，isa地址
    //观察45-63位，extra_rc表示retaincount-1
    BFPerson *person2 = person1;
    //(0x000021a100d88e3b) = (0000 0000 0000 0000 0000 0000 0010 0001 1010 0001 0000 0000 1101 1000 1000 1110 0011 1011)
    
    // 42: weakly_referenced，是否被弱引用
    __weak BFPerson *person3 = person1;
    //(0x000025a100d88e3b) = (0000 0000 0000 0000 0000 0000 0010 0101 1010 0001 0000 0000 1101 1000 1000 1110 0011 1011)
    
    NSLog(@"-----");
}

@end
