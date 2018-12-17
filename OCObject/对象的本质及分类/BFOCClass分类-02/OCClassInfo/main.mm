//
//  main.m
//  OCClassInfo
//
//  Created by WengHengcong on 2018/11/23.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BFPerson.h"
#import "BFStudent.h"
#import "BFTeacher.h"
#import "BFClassInfo.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        BFStudent *stu = [[BFStudent alloc] init];
        stu.age = 10;
        
        struct bf_objc_class *studentClass = (__bridge struct bf_objc_class *)([BFStudent class]);
        struct bf_objc_class *personClass = (__bridge struct bf_objc_class *)([BFPerson class]);
        
        struct class_rw_t *studentClassData = studentClass->data();
        class_rw_t *personClassData = personClass->data();
        
        class_rw_t *studentMetaClassData = studentClass->metaClass()->data();
        class_rw_t *personMetaClassData = personClass->metaClass()->data();

        NSLog(@"Hello, World!");
    }
    return 0;
}

void testClassInfo()
{
    
}
