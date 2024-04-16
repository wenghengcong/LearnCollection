//
//  Test_0301_0400.swift
//  LeetCodeSwiftTests
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import XCTest
@testable import LeetCodeSwift

final class Test_0301_0400: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_349()  {
        let res = E_349_Intersection().intersection([1,2,2,1], [2,2])
        print("res: \(res)")
        
        let res2 = E_349_Intersection().intersection([4,9,5], [9,4,9,8,4])
        print("res: \(res2)")
    }
}
