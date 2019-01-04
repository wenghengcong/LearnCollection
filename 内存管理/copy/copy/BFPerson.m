//
//  BFPerson.m
//  copy
//
//  Created by WengHengcong on 2019/1/2.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPerson.h"

@implementation BFPerson

//- (void)setData:(NSMutableArray *)data
//{
//    if (_data != data) {
//        //先释放旧对象
//        [_data release];
//        //再copy新对象，NSMutableArray copy出来是个NSArray对象，然后赋值给_data，假如_data在外部进行添加，就会导致崩溃
//        _data = [data copy];
//        //如何修复，将copy修饰符改为strong
//        _data = [data retain];
//    }
//}

- (id)copyWithZone:(NSZone *)zone
{
    BFPerson *person = [[BFPerson alloc] init];
    person.name = self.name;
    person.age = self.age;
    return person;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name = %@, age = %ld", self.name, (long)self.age];
}

@end
