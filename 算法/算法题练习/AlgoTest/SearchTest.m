//
//  SearchTest.m
//  AlgoTest
//
//  Created by WengHengcong on 2019/1/28.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BinarySearch.h"

@interface SearchTest : XCTestCase

@end

@implementation SearchTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    int sortedArr[10] = {2, 3, 5, 8, 11, 34, 45, 89, 100, 122};
    int length = 10;
    
    int search = [BinarySearch binarySearchByKey:11 array:sortedArr length:length];
    int search2 = [BinarySearch binarySearchByKey:100 array:sortedArr lower:0 high:length];
    NSLog(@"%d", search2);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
