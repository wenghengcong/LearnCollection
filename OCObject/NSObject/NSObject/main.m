//
//  main.m
//  NSObject
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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        // insert code here...
        NSObject *obj = [[NSObject alloc] init];
        
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        NSLog(@"%zu", malloc_size((__bridge const void *)(obj)));
        
        struct NSObject_IMPL *objImpl = (__bridge struct NSObject_IMPL *)obj;
        NSLog(@"obj address: %p", obj);
        NSLog(@"objImpl address: %p, objImpl isa: %p", objImpl, objImpl->isa);
        NSLog(@"-----");
    }
    return 0;
}
