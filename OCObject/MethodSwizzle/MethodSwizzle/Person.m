//
//  Person.m
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "Person.h"

@implementation Person

+ (void)load {
    NSLog(@"Person load");
}

- (void)sayHello {
    NSLog(@"Person class say hello");
}

@end
