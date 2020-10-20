//
//  Student.m
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "Student.h"

@implementation Student

+ (void)load {
    NSLog(@"Student load");
}

- (void)sayHello {
    NSLog(@"Student class say hello");
}

@end
