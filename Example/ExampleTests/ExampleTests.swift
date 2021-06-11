//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Александр Сенин on 10.06.2021.
//

import XCTest
@testable import RelizKit
@testable import Example

class ExampleTests: XCTestCase {
    var test: Bool?
    
    override func setUpWithError() throws {
        print("aaaa")
        test = true
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        print("bbbb")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        print("ccccc")
        XCTAssertEqual(true, test, "Ntst")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        print("ddddd")
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
