//
//  RZVBUIViewTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 17.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBUIViewTests: TestProtocol{
    
    static func test() {
        testCornerRadius()
        testAlpha()
        testMask()
        testIsHidden()
    }
    
    private static func testCornerRadius(){
        let view = UIView()
        
        let value: CGFloat = 10.0
        
        //MARK: - CGFloat
        view+>.cornerRadius(value)
        XCTAssertEqual(view.layer.cornerRadius, value, "Corner Radius")
        
        //MARK: - ProtoValue
        view+>.cornerRadius(value*)
        XCTAssertEqual(view.layer.cornerRadius, value, "Corner Radius, proto")
        
        view+>.cornerRadius(value* + value*)
        XCTAssertEqual(view.layer.cornerRadius, 2 * value, "Corner Radius, proto + proto")
        
        view+>.cornerRadius(value* - value*)
        XCTAssertEqual(view.layer.cornerRadius, 0, "Corner Radius, proto - proto")
        
        view+>.cornerRadius(value* * value*)
        XCTAssertEqual(view.layer.cornerRadius, value * value, "Corner Radius, proto * proto")
        
        view+>.cornerRadius(value* / value*)
        XCTAssertEqual(view.layer.cornerRadius, 1, "Corner Radius, proto / proto")
        
        view+>.cornerRadius(5 % value*)
        XCTAssertEqual(view.layer.cornerRadius, value * 0.05, "Corner Radius, % proto")
        
        view+>.cornerRadius(5* % value*)
        XCTAssertEqual(view.layer.cornerRadius, value * 0.05, "Corner Radius, % proto")
        
        //MARK: - RZObservable<CGFloat>
        let valueOb = RZObservable<CGFloat>(wrappedValue: 5.0)
        view+>.cornerRadius(valueOb)
        XCTAssertEqual(view.layer.cornerRadius, valueOb.wrappedValue, "Corner Radius, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.layer.cornerRadius, valueOb.wrappedValue, "Corner Radius, CGFloatOb after")

        //MARK: - RZObservable<ProtoValue>
        let valueProtoOb = RZObservable<RZProtoValue>(wrappedValue: 5.0*)
        view+>.cornerRadius(valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb after")
        
        view+>.cornerRadius(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb + protoOb after")
        
        view+>.cornerRadius(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, 0, "Corner Radius, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.layer.cornerRadius, 0, "Corner Radius, protoOb - protoOb after")
        
        view+>.cornerRadius(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.layer.cornerRadius, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "Corner Radius, protoOb * protoOb after")
        
        view+>.cornerRadius(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, 1, "Corner Radius, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.layer.cornerRadius, 1, "Corner Radius, protoOb / protoOb after")
        
        view+>.cornerRadius(5 % valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "Corner Radius, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.layer.cornerRadius, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "Corner Radius, % protoOb after")
        
        view+>.cornerRadius(5* % valueProtoOb*)
        XCTAssertEqual(view.layer.cornerRadius, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "Corner Radius, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.layer.cornerRadius, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "Corner Radius, proto % protoOb after")
    }
    
    private static func testAlpha(){
        let view = UIView()
        
        let value: CGFloat = 0.5
        
        //MARK: - CGFloat
        view+>.alpha(value)
        XCTAssertEqual(view.alpha, value, "Alpha")
        
        //MARK: - RZObservable<CGFloat>
        let valueOb = RZObservable<CGFloat>(wrappedValue: 0.3)
        view+>.alpha(valueOb)
        XCTAssertEqual((view.alpha * 10).rounded() / 10, valueOb.wrappedValue, "Alpha, CGFloatOb before")
        valueOb.wrappedValue = 0.8
        XCTAssertEqual((view.alpha * 10).rounded() / 10, valueOb.wrappedValue, "Alpha, CGFloatOb after")
        
    }
    
    private static func testMask() {
        let view = UIView()
        let button = UIButton()
        let value = UIImageView()
        
        view+>.mask(value)
        XCTAssertEqual(view.mask, value, "UIView mask")
        button+>.mask(value)
        XCTAssertEqual(button.mask, value, "UIButton mask")
    }
    
    private static func testIsHidden() {
        let label = UILabel()
        
        //MARK: - Bool
        let bool = true
        label+>.isHidden(bool)
        XCTAssertEqual(label.isHidden, bool, "UILabel isHidden")
        
        //MARK: - RZObservable<Bool>
        let boolOb = RZObservable<Bool>(wrappedValue: bool)
        label+>.isHidden(boolOb)
        XCTAssertEqual(label.isHidden, boolOb.wrappedValue, "UILabel isHidden ob before")
        boolOb.wrappedValue = false
        XCTAssertEqual(label.isHidden, boolOb.wrappedValue, "UILabel isHidden ob after")
    }
}
