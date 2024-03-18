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

class Test_91_120: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
}
