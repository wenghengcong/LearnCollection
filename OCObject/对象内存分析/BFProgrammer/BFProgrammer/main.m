//
//  main.m
//  BFProgrammer
//
//  Created by 翁恒丛 on 2018/11/10.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface BFPerson : NSObject
{
@public
    int _age;
    int _male;
    
@private
    double salary;
}
@property (nonatomic, assign) double height;
@end

@implementation BFPerson
@end

@interface BFProgrammer : BFPerson
{
    @public
    char *company;
}
@end

@implementation BFProgrammer

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        BFPerson *jack = [[BFPerson alloc] init];
        jack->_age = 24;
        jack->_male = 1;
        jack.height = 185;
//        NSLog(@"jack age is %d, male: %d, height: %f", jack->_age, jack->_male, jack.height);
//        NSLog(@"jack instance size: %zd", class_getInstanceSize([BFPerson class]));
//        NSLog(@"jack malloc size: %zd", malloc_size((__bridge const void *)jack));
        
        BFProgrammer *tony = [[BFProgrammer alloc] init];
        tony->_age = 28;
        tony->_male = 1;
        tony.height = 178;
        tony->company = "Google";
        NSLog(@"tony age is %d, male: %d, height: %f, company: %s", tony->_age, tony->_male, tony.height, tony->company);
        
        NSLog(@"tony instance size:%zd", class_getInstanceSize([BFProgrammer class]));
        NSLog(@"tony malloc size: %zd", malloc_size((__bridge const void *)tony));
    }
    return 0;
}
