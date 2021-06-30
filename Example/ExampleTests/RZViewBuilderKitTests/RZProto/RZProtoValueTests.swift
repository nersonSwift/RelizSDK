//
//  RZProtoValueTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 29.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZProtoValueTests: TestProtocol{
    static func test(){
        testGetValue()
        testSelfTag()
        testScreenTag()
    }
    
    private static func testGetValue(){
        let value: CGFloat = 5.0
        let protoValue: RZProtoValue = value*
        XCTAssertEqual(value, protoValue.getValue(), "getValue")
        
        
        let view = UIView()
        view+>.width(value)
        XCTAssertEqual(value, view*.w.getValue(), "getValue view*.w.getValue()")
        XCTAssertEqual(value, view*.getValue(.w).getValue(), "getValue view*.getValue(.w).getValue()")
    }
    
    private static func testSelfTag(){
        let view = UIView()
        
        //MARK: - w
        let width = 100*
        view+>.width(width).height(.selfTag(.w))
        XCTAssertEqual(view.frame.height, width.getValue(), ".selfTag(.w)")
        
        //MARK: - h
        let height = 50*
        view+>.height(height).width(.selfTag(.h))
        XCTAssertEqual(view.frame.width, height.getValue(), ".selfTag(.h)")
        
        //MARK: - x
        let x = 10*
        view+>.x(x).y(.selfTag(.x))
        XCTAssertEqual(view.frame.minY, x.getValue(), ".selfTag(.x)")
        
        //MARK: - mX
        view+>.x(x, .right).y(.selfTag(.mX))
        XCTAssertEqual(view.frame.minY, x.getValue(), ".selfTag(.mX)")
        
        //MARK: - cX
        view+>.x(x, .center).y(.selfTag(.cX))
        XCTAssertEqual(view.frame.midX, x.getValue(), ".selfTag(.cX)")
        
        //MARK: - y
        let y = 20*
        view+>.y(y).x(.selfTag(.y))
        XCTAssertEqual(view.frame.minX, y.getValue(), ".selfTag(.y)")

        //MARK: - mY
        view+>.y(y, .down).x(.selfTag(.mY))
        XCTAssertEqual(view.frame.minX, y.getValue(), ".selfTag(.mY)")
        
        //MARK: - cY
        view+>.y(y, .center).x(.selfTag(.cY))
        XCTAssertEqual(view.frame.midY, y.getValue(), ".selfTag(.cY)")
    }
    
    private static func testScreenTag(){
        let view = UIView()
        
        //MARK: - orientation vertical
        //MARK: - w
        view+>.width(.screenTag(.w))
        XCTAssertEqual(view.frame.width, UIScreen.main.bounds.width, ".screenTag(.w)")
        
        //MARK: - h
        view+>.height(.screenTag(.h))
        XCTAssertEqual(view.frame.height, UIScreen.main.bounds.height, ".screenTag(.h)")
        
        //MARK: - x
        view+>.x(.screenTag(.x))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.minX, ".screenTag(.x)")
        
        //MARK: - mX
        view+>.x(.screenTag(.mX))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.maxX, ".screenTag(.mX)")
        
        //MARK: - cX
        view+>.x(.screenTag(.cX))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.midX, ".screenTag(.cX)")
        
        //MARK: - y
        view+>.y(.screenTag(.y))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.minY, ".screenTag(.y)")

        //MARK: - mY
        view+>.y(.screenTag(.mY))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.maxY, ".screenTag(.mY)")
        
        //MARK: - cY
        view+>.y(.screenTag(.cY))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.midY, ".screenTag(.cY)")
        
        //MARK: - orientation horizontal
        //MARK: - w
        view+>.width(.screenTag(.w, .horizontal))
        XCTAssertEqual(view.frame.width, UIScreen.main.bounds.height, ".screenTag(.w)")
        
        //MARK: - h
        view+>.height(.screenTag(.h, .horizontal))
        XCTAssertEqual(view.frame.height, UIScreen.main.bounds.width, ".screenTag(.h)")
        
        //MARK: - x
        view+>.x(.screenTag(.x, .horizontal))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.minX, ".screenTag(.x)")
        
        //MARK: - mX
        view+>.x(.screenTag(.mX, .horizontal))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.maxY, ".screenTag(.mX)")
        
        //MARK: - cX
        view+>.x(.screenTag(.cX, .horizontal))
        XCTAssertEqual(view.frame.minX, UIScreen.main.bounds.midY, ".screenTag(.cX)")
        
        //MARK: - y
        view+>.y(.screenTag(.y, .horizontal))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.minY, ".screenTag(.y)")

        //MARK: - mY
        view+>.y(.screenTag(.mY, .horizontal))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.maxX, ".screenTag(.mY)")
        
        //MARK: - cY
        view+>.y(.screenTag(.cY, .horizontal))
        XCTAssertEqual(view.frame.minY, UIScreen.main.bounds.midX, ".screenTag(.cY)")
    }
}
