//
//  Person+Swizzle.h
//  MethodSwizzle
//
//  Created by Hunt on 2020/10/13.
//

#import "Person.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person (Swizzle)

- (void)p_sayHello;

@end

NS_ASSUME_NONNULL_END
