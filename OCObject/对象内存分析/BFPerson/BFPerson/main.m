//
//  main.m
//  BFPerson
//
//  Created by 翁恒丛 on 2018/11/9.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>


struct NSObject_IMPL {
    Class isa;
};

struct BFPerson_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    int _age;
    int _male;
    double _height;
};

@interface BFPerson : NSObject
{
    @public
    int _age;
    int _male;
}
@property (nonatomic, assign) double height;
@end

@implementation BFPerson

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        BFPerson *jack = [[BFPerson alloc] init];
        jack->_age = 24;
        jack->_male = 1;
        jack.height = 185;
        NSLog(@"jack age is %d, male: %d, height: %f", jack->_age, jack->_male, jack.height);
        struct BFPerson_IMPL *jackImpl = (__bridge struct BFPerson_IMPL *)jack;
        NSLog(@"jack age is %d, male: %d, height: %f", jackImpl->_age, jackImpl->_male, jackImpl->_height);
        
//        BFPerson *rose = [[BFPerson alloc] init];
//        rose->_age = 21;
//        rose->_male = 0;
//        rose.height = 165;
//        NSLog(@"rose age is %d, male: %d, height: %f", rose->_age, rose->_male, rose.height);
//
        NSLog(@"%zd", class_getInstanceSize([BFPerson class]));
        NSLog(@"%zd", malloc_size((__bridge const void *)jack));
//
        

    }
    return 0;
}
