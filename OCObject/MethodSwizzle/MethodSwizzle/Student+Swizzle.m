//
//  Student+Swizzle.m
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "Student+Swizzle.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation Student (Swizzle)

+ (void)load {
    NSLog(@"Student swizzle load");
    [self swizzleInstanceMethod:@selector(s_sayHello) with:@selector(sayHello)];
}

- (void)s_sayHello {
    NSLog(@"Student swizzle say hello");
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(originalSel), [self class]);
        return NO;
    }
    if (!newMethod) {
        NSLog(@"alternate method %@ not found for class %@", NSStringFromSelector(newSel), [self class]);
        return NO;
    }
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

@end
