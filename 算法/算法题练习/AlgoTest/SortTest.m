//
//  SortTest.m
//  AlgoTest
//
//  Created by WengHengcong on 2019/1/28.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SelectionSort.h"
#import "BubbleSort.h"

@interface SortTest : XCTestCase

@end

@implementation SortTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    int disorderArr[10] = {11, 2, 3, 34, 8, 122, 45, 5, 89, 100};
    int length = 10;
//    [SelectionSort sort:disorderArr length:length];
    [BubbleSort sort:disorderArr length:length];
    [BubbleSort printArray:disorderArr length:length];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
