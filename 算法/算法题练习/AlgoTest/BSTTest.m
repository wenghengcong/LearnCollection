//
//  BSTTest.m
//  AlgoTest
//
//  Created by WengHengcong on 2019/1/27.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BinarySearchTree.h"

@interface BSTTest : XCTestCase
@property (nonatomic, strong) BinarySearchTree *bstTree;
@end

@implementation BSTTest

- (void)setUp {
    int length = 10;
    int disorderArr[10] = {78, 45, 11, 8, 19, 23, 100, 9, 89, 145};
    self.bstTree = [[BinarySearchTree alloc] initWithArray:disorderArr length:length];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testOrder {
    [self.bstTree preOrder];
    [self.bstTree print];
    
    [self.bstTree inOrder];
    [self.bstTree print];
    
    [self.bstTree postOrder];
    [self.bstTree print];
}

- (void)testMinAndMax
{
    [self.bstTree print];
    NSLog(@"min: %@", [self.bstTree min]);
    NSLog(@"max: %@", [self.bstTree max]);
    
    //delete min
    [self.bstTree deleteMin];
    [self.bstTree deleteMax];
    NSLog(@"min: %@", [self.bstTree min]);
    NSLog(@"max: %@", [self.bstTree max]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
