//
//  Test_0401_0500.swift
//  LeetCodeSwiftTests
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import XCTest
@testable import LeetCodeSwift

final class Test_0401_0500: XCTestCase {

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
    
    func test_454() {
        let nums1 = [1,2], nums2 = [-2,-1], nums3 = [-1,2], nums4 = [0,2]
        let res = M_454_FourSumCount().fourSumCount(nums1, nums2, nums3, nums4)
        print("res: \(res)")
        
        let nums1_1 = [0], nums2_1 = [0], nums3_1 = [0], nums4_1 = [0]
        let res_1 = M_454_FourSumCount().fourSumCount(nums1_1, nums2_1, nums3_1, nums4_1)
        print("res: \(res_1)")
    }

}
