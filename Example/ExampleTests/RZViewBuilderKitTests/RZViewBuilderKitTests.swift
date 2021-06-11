//
//  RZViewBuilderKitTests.swift
//  ExampleTests
//
//  Created by Александр Сенин on 11.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZViewBuilderKitTests: XCTestCase {


    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        RZVBColorTests.testUIColor()
        RZVBColorTests.testRZOUIColor()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
