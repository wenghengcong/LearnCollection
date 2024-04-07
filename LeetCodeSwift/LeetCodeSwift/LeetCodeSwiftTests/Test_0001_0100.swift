//
//  Test_0000_0100.swift
//  LeetCodeSwiftTests
//
//  Created by Nemo on 2024/4/4.
//  Copyright © 2024 LuCi. All rights reserved.
//

import XCTest
@testable import LeetCodeSwift

final class Test_0001_0100: XCTestCase {

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

    func test_001() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let array = [2, 7, 11, 15]
        let target = 9
        let find = E_001_TwoSum.twoSum(array, target)
        print("TwoSum result: \(find)")
    }

    func test_007() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(E_007_ReverseInteger.reverse(120) == 21)
    }

    func test_014() {
        XCTAssert(E_014_LongestCommonPrefix.longestCommonPrefix(["flower","flow","flight"]) == "fl")
    }

    func test_019() {
        let l1_5 = ListNode(5), l1_4 = ListNode(4, l1_5), l1_3 = ListNode(3, l1_4), l1_2 = ListNode(2, l1_3), l1_1 = ListNode(1, l1_2)
        let head = M_019_RemoveNthFromEnd.removeNthFromEnd(l1_1, 2)
        head?.printAllNode()
    }

    func test_020() {
        XCTAssert(E_020_BracketsisValid.isValid("()[]{}") == true)
        XCTAssert(E_020_BracketsisValid.isValid("([)]") == false)
    }

    func test_021() {
        let l1_1 = ListNode(1), l1_2 = ListNode(2), l1_3 = ListNode(4)
        l1_1.next = l1_2
        l1_2.next = l1_3

        let l2_1 = ListNode(1), l2_2 = ListNode(3), l2_3 = ListNode(5)
        l2_1.next = l2_2
        l2_2.next = l2_3

        let newList = E_021_MergeTwoLists.mergeTwoLists(l1_1, l2_1)
        print(newList ?? "")
    }

    func test059() {
        let matrix = E_059_GenerateMatrix.generateMatrix(3)
        XCTAssertEqual(matrix, [[1,2,3],[8,9,4],[7,6,5]])
    }

    func test_066() {
        XCTAssert(E_066_PlusOne.plusOne([4, 5]) == [4, 6])
        XCTAssert(E_066_PlusOne.plusOne([4, 9, 9]) == [5, 0, 0])
        XCTAssert(E_066_PlusOne.plusOne([9, 9, 9]) == [1, 0, 0, 0])
    }

    func test_069() {
        let square = E_069_SquareOfX.mySqrt(8)
        XCTAssert(square == 2)
     }

    func test_070() {
        XCTAssert(E_070_ClimbStairs.climbStairs_1(2) == 2)
        XCTAssert(E_070_ClimbStairs.climbStairs_2(2) == 2)
        XCTAssert(E_070_ClimbStairs.climbStairs_3(2) == 2)
        XCTAssert(E_070_ClimbStairs.climbStairs_4(2) == 2)
        XCTAssert(E_070_ClimbStairs.climbStairs_5(2) == 2)

        XCTAssert(E_070_ClimbStairs.climbStairs_1(5) == 8)
        XCTAssert(E_070_ClimbStairs.climbStairs_2(5) == 8)
        XCTAssert(E_070_ClimbStairs.climbStairs_3(5) == 8)
        XCTAssert(E_070_ClimbStairs.climbStairs_4(5) == 8)
        XCTAssert(E_070_ClimbStairs.climbStairs_5(5) == 8)
    }


    func test_088() {
        var num1 = [1,2,3,0,0,0]
        let num2 =  [2,5,6]
        let m = 3 , n = 3
        E_088_MergeTowArray.merge(&num1, m, num2, n)

        XCTAssert(num1 == [1,2,2,3,5,6])
    }

    func test_024() {
        let l1_4 = ListNode(4), l1_3 = ListNode(3, l1_4), l1_2 = ListNode(2, l1_3), l1_1 = ListNode(1, l1_2)
        let head = M_024_SwapPairs.swapPairs(l1_1)
        head?.printAllNode()
    }
}
