//
//  main.m
//  OCObject
//
//  Created by 翁恒丛 on 2018/11/8.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSObject *obj = [[NSObject alloc] init];
        
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        NSLog(@"%zu", malloc_size((__bridge const void *)(obj)));
    }
    return 0;
}
