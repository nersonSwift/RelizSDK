//
//  RZVBUIScrollViewTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 18.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBUIScrollViewTests: TestProtocol{
    
    static func test() {
        testContentWidth()
        testContentHeight()
    }
    
    private static func testContentWidth(){
        let scroll = UIScrollView()
        
        //MARK: - CGFloat
        let value: CGFloat = 100
        scroll+>.contentWidth(value)
        XCTAssertEqual(scroll.contentSize.width, value, "UIScrollView contentWidth")
        
        //MARK: - ProtoValue
        scroll+>.contentWidth(value*)
        XCTAssertEqual(scroll.contentSize.width, value, "UIScrollView contentWidth proto")
        
        scroll+>.contentWidth(value* + 30*)
        XCTAssertEqual(scroll.contentSize.width, value + 30, "UIScrollView contentWidth value+protoValueNOb")
        
        scroll+>.contentWidth(value* - 30*)
        XCTAssertEqual(scroll.contentSize.width, value - 30, "UIScrollView contentWidth value-protoValueNOb")
        
        scroll+>.contentWidth(value* * 5*)
        XCTAssertEqual(scroll.contentSize.width, value * 5, "UIScrollView contentWidth value*protoValueNOb")
        
        scroll+>.contentWidth(value* / 3*)
        XCTAssertEqual(scroll.contentSize.width, value / 3, "UIScrollView contentWidth value/protoValueNOb")
        
        scroll+>.contentWidth(5 % value*)
        XCTAssertEqual(scroll.contentSize.width, value * 0.05, "UIScrollView contentWidth % value")
        
        scroll+>.contentWidth(5* % value*)
        XCTAssertEqual(scroll.contentSize.width, value * 0.05, "UIScrollView contentWidth proto % value")
    }
    
    private static func testContentHeight(){
        let scroll = UIScrollView()
        
        //MARK: - CGFloat
        let value: CGFloat = 200
        scroll+>.contentHeight(value)
        XCTAssertEqual(scroll.contentSize.height, value, "UIScrollView contentHeight")
        
        //MARK: - ProtoValue
        scroll+>.contentHeight(value*)
        XCTAssertEqual(scroll.contentSize.height, value, "UIScrollView contentHeight proto")
        
        scroll+>.contentHeight(value* + 30*)
        XCTAssertEqual(scroll.contentSize.height, value + 30, "UIScrollView contentHeight value+protoValueNOb")
        
        scroll+>.contentHeight(value* - 30*)
        XCTAssertEqual(scroll.contentSize.height, value - 30, "UIScrollView contentHeight value-protoValueNOb")
        
        scroll+>.contentHeight(value* * 5*)
        XCTAssertEqual(scroll.contentSize.height, value * 5, "UIScrollView contentHeight value*protoValueNOb")
        
        scroll+>.contentHeight(value* / 3*)
        XCTAssertEqual(scroll.contentSize.height, value / 3, "UIScrollView contentHeight value/protoValueNOb")
        
        scroll+>.contentHeight(5 % value*)
        XCTAssertEqual(scroll.contentSize.height, value * 0.05, "UIScrollView contentHeight % value")
        
        scroll+>.contentHeight(5* % value*)
        XCTAssertEqual(scroll.contentSize.height, value * 0.05, "UIScrollView contentHeight proto % value")
    }
}
