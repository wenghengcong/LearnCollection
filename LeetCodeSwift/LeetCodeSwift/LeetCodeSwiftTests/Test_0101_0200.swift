//
//  Test_91_120.swift
//  LeetCodeSwiftTests
//
//  Created by Hunt on 2020/7/15.
//  Copyright © 2020 LuCi. All rights reserved.
//

import Foundation
import XCTest
@testable import LeetCodeSwift

class Test_0101_0200: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_103() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(E_013_RomanToInt.romanToInt("III") == 3)
        XCTAssert(E_013_RomanToInt.romanToInt("IX") == 4)
        XCTAssert((E_013_RomanToInt.romanToInt("LVIII")) == 58)
        XCTAssert((E_013_RomanToInt.romanToInt("MCMXCIV")) == 1994)
    }
    
    func test_120() {
        let triangle = [[2], [3,4], [6,5,7], [4,1,8,3]]
        let totoal = M_120_TriangleMinimumTotal.minimumTotal(triangle)
        print("minium total of triangle : \(totoal)")
        
        let totoal2 = M_120_TriangleMinimumTotal.minimumTotalQuickly(triangle)
        print("minium total of triangle 2: \(totoal2)")
        
        let totoal3 = M_120_TriangleMinimumTotal.minimumTotalQuickly_2(triangle)
        print("minium total of triangle 3: \(totoal3)")
    }
    
    
    func test_125() {
        let s1 = "A man, a plan, a canal: Panama"
        let s2 = "race a car"
        XCTAssert(E_125_IsPalindrome.isPalindrome(s1) == true)
        XCTAssert(E_125_IsPalindrome.isPalindrome(s2) == false)
    }
    
    func test_136() {
        let s1 = [2, 2, 1]
        let s2 = [4,1,2,1,2]
        XCTAssert(E_136_SingleNumber.singleNumber(s1) == 1)
        XCTAssert(E_136_SingleNumber.singleNumber(s2) == 4)
    }

    func test_142() {

        let l1_1 = ListNode(3)
        let l1_2 = ListNode(2)
        let l1_3 = ListNode(0)
        let l1_4 = ListNode(4)  // 3-2-0-4<->2
        l1_1.next = l1_2
        l1_2.next = l1_3
        l1_3.next = l1_4
        l1_4.next = l1_2

        let cycleIndex = M_142_DetectCycle.detectCycle(l1_1)
        print("cycle index: \(cycleIndex?.val)")
    }

    func test_160() {
        let same_1 = ListNode(5), same_2 = ListNode(4, same_1), same_3 = ListNode(8, same_2)

        let l1_1 = ListNode(1, same_3), l1_2 = ListNode(4, l1_1) // 4-1-8-4-5
        let l2_1 = ListNode(1, same_3), l2_2 = ListNode(6, l2_1), l2_3 = ListNode(5, l2_2)  //5-6-1-8-4-5

        let interact_1 = E_160_GetIntersectionNode.getIntersectionNode_2(l2_3, l1_2);
        interact_1?.printAllNode()

        let l3_1 = ListNode(2), l3_2 = ListNode(6, l3_1), l3_3 = ListNode(4, l3_2)  // 2-6-4
        let l4_1 = ListNode(5), l4_2 = ListNode(1, l4_1)                            //1-5
        let interact_2 = E_160_GetIntersectionNode.getIntersectionNode_2(l3_3, l4_2);
        interact_2?.printAllNode()
    }

}
