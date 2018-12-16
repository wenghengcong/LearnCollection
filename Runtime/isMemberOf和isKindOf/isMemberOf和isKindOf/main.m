//
//  main.m
//  isMemberOf和isKindOf
//
//  Created by WengHengcong on 2018/12/16.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BFPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"%d", [[NSObject class] isKindOfClass:[NSObject class]]);
        NSLog(@"%d", [[NSObject class] isMemberOfClass:[NSObject class]]);
        NSLog(@"%d", [[BFPerson class] isKindOfClass:[BFPerson class]]);
        NSLog(@"%d", [[BFPerson class] isMemberOfClass:[BFPerson class]]);
        NSLog(@"------------------");
        
        // 这句代码的方法调用者不管是哪个类（只要是NSObject体系下的），都返回YES
        NSLog(@"%d", [NSObject isKindOfClass:[NSObject class]]);        // 1
        NSLog(@"%d", [NSObject isMemberOfClass:[NSObject class]]);      // 0
        NSLog(@"%d", [BFPerson isKindOfClass:[BFPerson class]]);        // 0
        NSLog(@"%d", [BFPerson isMemberOfClass:[BFPerson class]]);      // 0
        NSLog(@"------------------");
        
        //正常使用实例对象
        BFPerson *person = [[BFPerson alloc] init];
        NSLog(@"%d", [person isMemberOfClass:[BFPerson class]]);
        NSLog(@"%d", [person isMemberOfClass:[NSObject class]]);
        NSLog(@"%d", [person isKindOfClass:[BFPerson class]]);
        NSLog(@"%d", [person isKindOfClass:[NSObject class]]);
    }
    return 0;
}


//@implementation NSObject
//
//- (BOOL)isMemberOfClass:(Class)cls {
//    return [self class] == cls;
//}
//
//- (BOOL)isKindOfClass:(Class)cls {
//    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
//        if (tcls == cls) return YES;
//    }
//    return NO;
//}
//
//
//+ (BOOL)isMemberOfClass:(Class)cls {
//    return object_getClass((id)self) == cls;
//}
//
//
//+ (BOOL)isKindOfClass:(Class)cls {
//    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
//        if (tcls == cls) return YES;
//    }
//    return NO;
//}
//@end
