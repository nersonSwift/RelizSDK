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
        RZVBColorTests.test()
        RZVBFrameTests.test()
        RZVBUIViewTests.test()
        RZVBTransformTests.test()
        RZVBTextandFontTests.test()
        RZVBImageTests.test()
        RZVBUIScrollViewTests.test()
        RZProtoValueTests.test()
        RZProtoOperationsTests.test()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            RZVBFrameTests.test()
        }
    }

}
