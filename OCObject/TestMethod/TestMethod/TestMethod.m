//
//  TestMethod.m
//  TestMethod
//
//  Created by Nemo on 2024/9/21.
//

#import "TestMethod.h"

@implementation TestMethod

- (void)testFloat:(NSTimeInterval)time {
    NSLog(@"%ld", (long)time);
}

- (void)testInt:(NSInteger)time {
    NSLog(@"%ld", time);
}

@end
