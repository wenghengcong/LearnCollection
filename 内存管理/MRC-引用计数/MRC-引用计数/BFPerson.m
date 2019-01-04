//
//  BFPerson.m
//  MRC-引用计数
//
//  Created by WengHengcong on 2019/1/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson
@synthesize age = _age;
@synthesize name = _name;
@synthesize book = _book;
@synthesize pen = _pen;

- (void)setAge:(NSInteger)age
{
    _age = age;
}

-(NSInteger)age
{
    return _age;
}


- (void)setName:(NSString *)name
{
    if (_name != name) {
        [_name release];
        _name = [name copy];
    }
}

- (NSString *)name
{
    return _name;
}


/**
 实现一
 */
//- (void)setBook:(BFBook *)book
//{
//    _book = [book retain];
//}


/**
 实现二
 */
//- (void)setBook:(BFBook *)book
//{
//    [_book release];
//    _book = [book retain];
//}

- (void)setBook:(BFBook *)book
{
    if (_book != book) {
        [_book release];
        _book = [book retain];
    }
}

- (BFBook *)book
{
    return _book;
}

- (void)setPen:(BFPen *)pen
{
    if (_pen != pen) {
        _pen = pen;
    }
}

- (BFPen *)pen
{
    return _pen;
}


- (void)eat
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    // 清理各种资源
    //age不需要清理

    self.name = nil;    //相当于下面两句
//    [_name release];
//    _name = nil;

    [_book release];
    _book = nil;
    
    //pen也不需要清理
    
    // 注意:super dealloc一定要写到所有代码的最后
    [super dealloc];
}

@end
