//
//  Student+Swizzle.h
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "Student.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student (Swizzle)

- (void)s_sayHello;

@end

NS_ASSUME_NONNULL_END
