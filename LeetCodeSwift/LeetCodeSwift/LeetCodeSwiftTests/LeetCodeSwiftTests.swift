//
//  LeetCodeSwiftTests.swift
//  LeetCodeSwiftTests
//
//  Created by Hunt on 2019/8/6.
//  Copyright © 2019 LuCi. All rights reserved.
//

import XCTest
@testable import LeetCodeSwift

class LeetCodeSwiftTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTwoSum() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let array = [2, 7, 11, 15]
        let target = 9
        let find = E_001_TwoSum.twoSum(array, target)
        print("TwoSum result: \(find)")
    }
    
    func testReverseInteger() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(E_007_ReverseInteger.reverse(120) == 21)
    }
    
    func testRomanToInt() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(E_013_RomanToInt.romanToInt("III") == 3)
        XCTAssert(E_013_RomanToInt.romanToInt("IX") == 4)
        XCTAssert((E_013_RomanToInt.romanToInt("LVIII")) == 58)
        XCTAssert((E_013_RomanToInt.romanToInt("MCMXCIV")) == 1994)
    }
    
    func testLongestCommonPrefix() {
        XCTAssert(E_014_LongestCommonPrefix.longestCommonPrefix(["flower","flow","flight"]) == "fl")
    }
    
    func testBracketsisValid() {
        XCTAssert(E_020_BracketsisValid.isValid("()[]{}") == true)
        XCTAssert(E_020_BracketsisValid.isValid("([)]") == false)
    }
    
    func testMergeTwoList() {
        let l1_1 = ListNode(1), l1_2 = ListNode(2), l1_3 = ListNode(4)
        l1_1.next = l1_2
        l1_2.next = l1_3
        
        let l2_1 = ListNode(1), l2_2 = ListNode(3), l2_3 = ListNode(5)
        l2_1.next = l2_2
        l2_2.next = l2_3
        
        let newList = E_021_MergeTwoLists.mergeTwoLists(l1_1, l2_1)
        print(newList ?? "")
    }
    
    func testSquareOfX() {
        let square = E_069_SquareOfX.mySqrt(8)
        XCTAssert(square == 2)
     }
    
    func testClimbStairs() {
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
    
    func testPlusOne() {
        XCTAssert(E_066_PlusOne.plusOne([4, 5]) == [4, 6])
        XCTAssert(E_066_PlusOne.plusOne([4, 9, 9]) == [5, 0, 0])
        XCTAssert(E_066_PlusOne.plusOne([9, 9, 9]) == [1, 0, 0, 0])
    }
    
    func testMergeTwoArray() {
        var num1 = [1,2,3,0,0,0]
        let num2 =  [2,5,6]
        let m = 3 , n = 3
        E_088_MergeTowArray.merge(&num1, m, num2, n)
        
        XCTAssert(num1 == [1,2,2,3,5,6])
    }
    
    func testMoveZeroes() {
        var nums = [0,1,0,3,12]
        let result = [1,3,12,0,0]
        E_283_MoveZeroes.moveZeroes(&nums)
        XCTAssert(nums == result)
    }
    
     func testMissingNumber() {
//        var nums = [9,6,4,2,3,5,7,0,1]
//        MoveZeroes.moveZeroes(&nums)
//        XCTAssert(MissingNumber.missingNumber(nums) == 8)
        let nums2 = [3,0,1]
        XCTAssert(E_268_MissingNumber.missingNumber(nums2) == 2)
     }
    
    func testIsPalindrom() {
        let s1 = "A man, a plan, a canal: Panama"
        let s2 = "race a car"
        XCTAssert(E_125_IsPalindrome.isPalindrome(s1) == true)
        XCTAssert(E_125_IsPalindrome.isPalindrome(s2) == false)
     }
    
    func testIsHappy() {
        let s1 = 19
        let s2 = 24
        XCTAssert(E_202_HappyNumber.isHappy(s1) == true)
        XCTAssert(E_202_HappyNumber.isHappy(s2) == false)
    }
    
    func testSingleNumber() {
        let s1 = [2, 2, 1]
        let s2 = [4,1,2,1,2]
        XCTAssert(E_136_SingleNumber.singleNumber(s1) == 1)
        XCTAssert(E_136_SingleNumber.singleNumber(s2) == 4)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
