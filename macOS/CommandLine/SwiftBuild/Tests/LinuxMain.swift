import XCTest

import SwiftBuildTests

var tests = [XCTestCaseEntry]()
tests += SwiftBuildTests.allTests()
XCTMain(tests)