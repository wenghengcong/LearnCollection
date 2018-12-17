//
//  ViewController.m
//  objc_msgSend
//
//  Created by WengHengcong on 2018/12/14.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"dog"];
        NSInteger index = [array indexOfObject:@"dog"];
        NSString *last = [array lastObject];
        [array removeLastObject];
    }
    
    {
        NSMutableArray *array = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend) ( (id)[NSMutableArray class], @selector(alloc) );
        array = ( (NSMutableArray * (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(init));
        ( (void (*) (id, SEL, NSString *)) objc_msgSend) ( (id)array, @selector(addObject:), @"dog");
        NSInteger index = ( (NSInteger (*) (id, SEL, NSString *)) objc_msgSend) ( (id)array, @selector(indexOfObject:), @"dog");
        NSString *last = ( (NSString * (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(lastObject));
        ( (void (*) (id, SEL)) objc_msgSend) ( (id)array, @selector(removeLastObject));
        NSLog(@"%@--", array);
    }

}

@end
