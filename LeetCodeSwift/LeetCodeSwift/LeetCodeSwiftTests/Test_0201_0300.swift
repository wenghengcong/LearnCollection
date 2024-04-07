//
//  Test_0201_0300.swift
//  LeetCodeSwiftTests
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import XCTest
@testable import LeetCodeSwift

final class Test_0201_0300: XCTestCase {

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

    func test_202() {
        let s1 = 19
        let s2 = 24
        XCTAssert(E_202_HappyNumber.isHappy(s1) == true)
        XCTAssert(E_202_HappyNumber.isHappy(s2) == false)
    }

    func test_203() {
        let l1_7 = ListNode(6), l1_6 = ListNode(5, l1_7), l1_5 = ListNode(4, l1_6)
        let l1_4 = ListNode(3, l1_5), l1_3 = ListNode(6, l1_4), l1_2 = ListNode(2, l1_3), l1_1 = ListNode(1, l1_2)
        let l1_remove = 6
        l1_1.printAllNode()
        let l1_newHead = E_203_RemoveElements.removeElements_2(l1_1, l1_remove)
        l1_newHead?.printAllNode()

        let l2_4 = ListNode(7), l2_3 = ListNode(7, l2_4), l2_2 = ListNode(7, l2_3), l2_1 = ListNode(7, l2_2)
        let l2_remove = 7
        l2_1.printAllNode()
        let l2_newHead = E_203_RemoveElements.removeElements_2(l2_1, l2_remove)
        l2_newHead?.printAllNode()

        let l3_4 = ListNode(4), l3_3 = ListNode(2, l3_4), l3_2 = ListNode(4, l3_3), l3_1 = ListNode(1, l3_2)
        let l3_remove = 1
        l3_1.printAllNode()
        let l3_newHead = E_203_RemoveElements.removeElements_2(l3_1, l3_remove)
        l3_newHead?.printAllNode()
    }

    func test_268() {
        //        var nums = [9,6,4,2,3,5,7,0,1]
        //        MoveZeroes.moveZeroes(&nums)
        //        XCTAssert(MissingNumber.missingNumber(nums) == 8)
        let nums2 = [3,0,1]
        XCTAssert(E_268_MissingNumber.missingNumber(nums2) == 2)
    }

    func test_283() {
        var nums = [0,1,0,3,12]
        let result = [1,3,12,0,0]
        E_283_MoveZeroes.moveZeroes(&nums)
        XCTAssert(nums == result)
    }


}
