//
//  RZVBTransformTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 17.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBTransformTests: TestProtocol{
    
    static func test() {
        testTCoordinates()
        testTABCD()
        testTransform()
    }
    
    private static func testTCoordinates(){
        let view = UIView()
        
        let value: CGFloat = 10.0
        
        //MARK: - tx
        //MARK: - CGFloat
        view+>.tx(value)
        XCTAssertEqual(view.transform.tx, value, "tx, CGFloat")
        
        //MARK: - ProtoValue
        view+>.tx(value*)
        XCTAssertEqual(view.transform.tx, value, "tx, proto")
        
        view+>.tx(value* + value*)
        XCTAssertEqual(view.transform.tx, 2 * value, "tx, proto + proto")
        
        view+>.tx(value* - value*)
        XCTAssertEqual(view.transform.tx, 0, "tx, proto - proto")
        
        view+>.tx(value* * value*)
        XCTAssertEqual(view.transform.tx, value * value, "tx, proto * proto")
        
        view+>.tx(value* / value*)
        XCTAssertEqual(view.transform.tx, 1, "tx, proto / proto")
        
        view+>.tx(5 % value*)
        XCTAssertEqual(view.transform.tx, value * 0.05, "tx, % proto")
        
        view+>.tx(5* % value*)
        XCTAssertEqual(view.transform.tx, value * 0.05, "tx, % proto")
        
        //MARK: - RZObservable<CGFloat>
        let valueOb = RZObservable<CGFloat>(wrappedValue: 5.0)
        view+>.tx(valueOb)
        XCTAssertEqual(view.transform.tx, valueOb.wrappedValue, "tx, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.tx, valueOb.wrappedValue, "tx, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        let valueProtoOb = RZObservable<RZProtoValue>(wrappedValue: 5.0*)
        view+>.tx(valueProtoOb*)
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue(), "tx, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue(), "tx, protoOb after")
        
        view+>.tx(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tx, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tx, protoOb + protoOb after")
        
        view+>.tx(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.tx, 0, "tx, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.tx, 0, "tx, protoOb - protoOb after")
        
        view+>.tx(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tx, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.tx, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tx, protoOb * protoOb after")
        
        view+>.tx(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.tx, 1, "tx, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.tx, 1, "tx, protoOb / protoOb after")
        
        view+>.tx(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.tx, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tx, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.tx, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tx, % protoOb after")
        
        view+>.tx(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.tx, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tx, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.tx, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tx, proto % protoOb after")
        
        //MARK: - ty
        //MARK: - CGFloat
        view+>.ty(value)
        XCTAssertEqual(view.transform.ty, value, "ty, CGFloat")
        
        //MARK: - ProtoValue
        view+>.ty(value*)
        XCTAssertEqual(view.transform.ty, value, "ty, proto")
        
        view+>.ty(value* + value*)
        XCTAssertEqual(view.transform.ty, 2 * value, "ty, proto + proto")
        
        view+>.ty(value* - value*)
        XCTAssertEqual(view.transform.ty, 0, "ty, proto - proto")
        
        view+>.ty(value* * value*)
        XCTAssertEqual(view.transform.ty, value * value, "ty, proto * proto")
        
        view+>.ty(value* / value*)
        XCTAssertEqual(view.transform.ty, 1, "ty, proto / proto")
        
        view+>.ty(5 % value*)
        XCTAssertEqual(view.transform.ty, value * 0.05, "ty, % proto")
        
        view+>.ty(5* % value*)
        XCTAssertEqual(view.transform.ty, value * 0.05, "ty, % proto")
        
        //MARK: - RZObservable<CGFloat>
        view+>.ty(valueOb)
        XCTAssertEqual(view.transform.ty, valueOb.wrappedValue, "ty, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.ty, valueOb.wrappedValue, "ty, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        view+>.ty(valueProtoOb*)
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue(), "ty, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue(), "ty, protoOb after")
        
        view+>.ty(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "ty, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "ty, protoOb + protoOb after")
        
        view+>.ty(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.ty, 0, "ty, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.ty, 0, "ty, protoOb - protoOb after")
        
        view+>.ty(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "ty, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.ty, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "ty, protoOb * protoOb after")
        
        view+>.ty(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.ty, 1, "ty, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.ty, 1, "ty, protoOb / protoOb after")
        
        view+>.ty(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.ty, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ty, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.ty, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ty, % protoOb after")
        
        view+>.ty(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.ty, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ty, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.ty, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ty, proto % protoOb after")
    }
    
    private static func testTABCD(){
        let view = UIView()
        
        let value: CGFloat = 5.0
        
        //MARK: - ta
        //MARK: - CGFloat
        view+>.ta(value)
        XCTAssertEqual(view.transform.a, value, "ta, CGFloat")
        
        //MARK: - ProtoValue
        view+>.ta(value*)
        XCTAssertEqual(view.transform.a, value, "ta, proto")
        
        view+>.ta(value* + value*)
        XCTAssertEqual(view.transform.a, 2 * value, "ta, proto + proto")
        
        view+>.ta(value* - value*)
        XCTAssertEqual(view.transform.a, 0, "ta, proto - proto")
        
        view+>.ta(value* * value*)
        XCTAssertEqual(view.transform.a, value * value, "ta, proto * proto")
        
        view+>.ta(value* / value*)
        XCTAssertEqual(view.transform.a, 1, "ta, proto / proto")
        
        view+>.ta(5 % value*)
        XCTAssertEqual(view.transform.a, value * 0.05, "ta, % proto")
        
        view+>.ta(5* % value*)
        XCTAssertEqual(view.transform.a, value * 0.05, "ta, % proto")
        
        //MARK: - RZObservable<CGFloat>
        let valueOb = RZObservable<CGFloat>(wrappedValue: 5.0)
        view+>.ta(valueOb)
        XCTAssertEqual(view.transform.a, valueOb.wrappedValue, "ta, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.a, valueOb.wrappedValue, "ta, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        let valueProtoOb = RZObservable<RZProtoValue>(wrappedValue: 5.0*)
        view+>.ta(valueProtoOb*)
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue(), "ta, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue(), "ta, protoOb after")
        
        view+>.ta(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "ta, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "ta, protoOb + protoOb after")
        
        view+>.ta(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.a, 0, "ta, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.a, 0, "ta, protoOb - protoOb after")
        
        view+>.ta(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "ta, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.a, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "ta, protoOb * protoOb after")
        
        view+>.ta(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.a, 1, "ta, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.a, 1, "ta, protoOb / protoOb after")
        
        view+>.ta(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.a, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ta, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.a, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ta, % protoOb after")
        
        view+>.ta(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.a, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ta, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.a, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "ta, proto % protoOb after")
        
        //MARK: - tb
        //MARK: - CGFloat
        view+>.tb(value)
        XCTAssertEqual(view.transform.b, value, "tb, CGFloat")
        
        //MARK: - ProtoValue
        view+>.tb(value*)
        XCTAssertEqual(view.transform.b, value, "tb, proto")
        
        view+>.tb(value* + value*)
        XCTAssertEqual(view.transform.b, 2 * value, "tb, proto + proto")
        
        view+>.tb(value* - value*)
        XCTAssertEqual(view.transform.b, 0, "tb, proto - proto")
        
        view+>.tb(value* * value*)
        XCTAssertEqual(view.transform.b, value * value, "tb, proto * proto")
        
        view+>.tb(value* / value*)
        XCTAssertEqual(view.transform.b, 1, "tb, proto / proto")
        
        view+>.tb(5 % value*)
        XCTAssertEqual(view.transform.b, value * 0.05, "tb, % proto")
        
        view+>.tb(5* % value*)
        XCTAssertEqual(view.transform.b, value * 0.05, "tb, % proto")
        
        //MARK: - RZObservable<CGFloat>
        view+>.tb(valueOb)
        XCTAssertEqual(view.transform.b, valueOb.wrappedValue, "tb, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.b, valueOb.wrappedValue, "tb, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        view+>.tb(valueProtoOb*)
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue(), "tb, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue(), "tb, protoOb after")
        
        view+>.tb(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tb, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tb, protoOb + protoOb after")
        
        view+>.tb(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.b, 0, "tb, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.b, 0, "tb, protoOb - protoOb after")
        
        view+>.tb(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tb, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.b, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tb, protoOb * protoOb after")
        
        view+>.tb(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.b, 1, "tb, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.b, 1, "tb, protoOb / protoOb after")
        
        view+>.tb(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.b, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tb, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.b, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tb, % protoOb after")
        
        view+>.tb(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.b, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tb, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.b, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tb, proto % protoOb after")
        
        //MARK: - tc
        //MARK: - CGFloat
        view+>.tc(value)
        XCTAssertEqual(view.transform.c, value, "tc, CGFloat")
        
        //MARK: - ProtoValue
        view+>.tc(value*)
        XCTAssertEqual(view.transform.c, value, "tc, proto")
        
        view+>.tc(value* + value*)
        XCTAssertEqual(view.transform.c, 2 * value, "tc, proto + proto")
        
        view+>.tc(value* - value*)
        XCTAssertEqual(view.transform.c, 0, "tc, proto - proto")
        
        view+>.tc(value* * value*)
        XCTAssertEqual(view.transform.c, value * value, "tc, proto * proto")
        
        view+>.tc(value* / value*)
        XCTAssertEqual(view.transform.c, 1, "tc, proto / proto")
        
        view+>.tc(5 % value*)
        XCTAssertEqual(view.transform.c, value * 0.05, "tc, % proto")
        
        view+>.tc(5* % value*)
        XCTAssertEqual(view.transform.c, value * 0.05, "tc, % proto")
        
        //MARK: - RZObservable<CGFloat>
        view+>.tc(valueOb)
        XCTAssertEqual(view.transform.c, valueOb.wrappedValue, "tc, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.c, valueOb.wrappedValue, "tc, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        view+>.tc(valueProtoOb*)
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue(), "tc, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue(), "tc, protoOb after")
        
        view+>.tc(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tc, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "tc, protoOb + protoOb after")
        
        view+>.tc(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.c, 0, "tc, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.c, 0, "tc, protoOb - protoOb after")
        
        view+>.tc(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tc, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.c, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "tc, protoOb * protoOb after")
        
        view+>.tc(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.c, 1, "tc, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.c, 1, "tc, protoOb / protoOb after")
        
        view+>.tc(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.c, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tc, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.c, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tc, % protoOb after")
        
        view+>.tc(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.c, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tc, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.c, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "tc, proto % protoOb after")
        
        //MARK: - td
        //MARK: - CGFloat
        view+>.td(value)
        XCTAssertEqual(view.transform.d, value, "td, CGFloat")
        
        //MARK: - ProtoValue
        view+>.td(value*)
        XCTAssertEqual(view.transform.d, value, "td, proto")
        
        view+>.td(value* + value*)
        XCTAssertEqual(view.transform.d, 2 * value, "td, proto + proto")
        
        view+>.td(value* - value*)
        XCTAssertEqual(view.transform.d, 0, "td, proto - proto")
        
        view+>.td(value* * value*)
        XCTAssertEqual(view.transform.d, value * value, "td, proto * proto")
        
        view+>.td(value* / value*)
        XCTAssertEqual(view.transform.d, 1, "td, proto / proto")
        
        view+>.td(5 % value*)
        XCTAssertEqual(view.transform.d, value * 0.05, "td, % proto")
        
        view+>.td(5* % value*)
        XCTAssertEqual(view.transform.d, value * 0.05, "td, % proto")
        
        //MARK: - RZObservable<CGFloat>
        view+>.td(valueOb)
        XCTAssertEqual(view.transform.d, valueOb.wrappedValue, "td, CGFloatOb before")
        valueOb.wrappedValue = 7.0
        XCTAssertEqual(view.transform.d, valueOb.wrappedValue, "td, CGFloatOb after")
        
        //MARK: - RZObservable<ProtoValue>
        view+>.td(valueProtoOb*)
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue(), "td, protoOb before")
        valueProtoOb.wrappedValue = 6.0*
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue(), "td, protoOb after")
        
        view+>.td(valueProtoOb* + valueProtoOb*)
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "td, protoOb + protoOb before")
        valueProtoOb.wrappedValue = 10.0*
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue() + valueProtoOb.wrappedValue.getValue(), "td, protoOb + protoOb after")
        
        view+>.td(valueProtoOb* - valueProtoOb*)
        XCTAssertEqual(view.transform.d, 0, "td, protoOb - protoOb before")
        valueProtoOb.wrappedValue = 2.0*
        XCTAssertEqual(view.transform.d, 0, "td, protoOb - protoOb after")
        
        view+>.td(valueProtoOb* * valueProtoOb*)
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "td, protoOb * protoOb before")
        valueProtoOb.wrappedValue = 3.0*
        XCTAssertEqual(view.transform.d, valueProtoOb.wrappedValue.getValue() * valueProtoOb.wrappedValue.getValue(), "td, protoOb * protoOb after")
        
        view+>.td(valueProtoOb* / valueProtoOb*)
        XCTAssertEqual(view.transform.d, 1, "td, protoOb / protoOb before")
        valueProtoOb.wrappedValue = 7.0*
        XCTAssertEqual(view.transform.d, 1, "td, protoOb / protoOb after")
        
        view+>.td(5 % valueProtoOb*)
        XCTAssertEqual(view.transform.d, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "td, % protoOb before")
        valueProtoOb.wrappedValue = 8.0*
        XCTAssertEqual(view.transform.d, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "td, % protoOb after")
        
        view+>.td(5* % valueProtoOb*)
        XCTAssertEqual(view.transform.d, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "td, proto % protoOb before")
        valueProtoOb.wrappedValue = 4.0*
        XCTAssertEqual(view.transform.d, (valueProtoOb.wrappedValue.getValue() / 100) * 5, "td, proto % protoOb after")
    }
    
    private static func testTransform(){
        let view = UIView()
        
        //MARK: - CGAffineTransform
        let value: CGAffineTransform = CGAffineTransform(a: 1, b: 2, c: 3, d: 4, tx: 5, ty: 6)
        view+>.transform(value)
        XCTAssertEqual(view.transform, value, "transform")
        
        //MARK: - RZObservable<CGAffineTransform>
        let valueOb = RZObservable<CGAffineTransform>(wrappedValue: value)
        view+>.transform(valueOb)
        XCTAssertEqual(view.transform, valueOb.wrappedValue, "transformOb before")
        valueOb.wrappedValue = CGAffineTransform(a: 7, b: 2, c: 1, d: 4, tx: 3, ty: 7)
        XCTAssertEqual(view.transform, valueOb.wrappedValue, "transformOb after")
    }
}
