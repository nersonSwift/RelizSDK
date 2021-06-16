//
//  RZVBFrameTests.swift
//  ExampleTests
//
//  Created by Александр Сенин on 11.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZVBFrameTests: TestProtocol{
    
    
    static func test() {
        testHeight()
        testWidth()
        testMinX()
        testMidX()
        testMinY()
        testMaxX()
        testMidY()
        testMaxY()
    }
    
    private static func testHeight(){
        testFrameElement(\.height, "height"){
            switch $1{
            case let value as CGFloat: $0+>.height(value)
            case let value as RZProtoValue: $0+>.height(value)
            case let value as RZObservable<RZProtoValue>: $0+>.height(value)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testWidth(){
        testFrameElement(\.width, "width"){
            switch $1{
            case let value as CGFloat: $0+>.width(value)
            case let value as RZProtoValue: $0+>.width(value)
            case let value as RZObservable<RZProtoValue>: $0+>.width(value)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMinX(){
        testFrameElement(\.minX, "minX"){
            switch $1{
            case let value as CGFloat: $0+>.x(value)
            case let value as RZProtoValue: $0+>.x(value)
            case let value as RZObservable<RZProtoValue>: $0+>.x(value)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMidX(){
        testFrameElement(\.midX, "midX"){
            switch $1{
            case let value as CGFloat: $0+>.x(value, .center)
            case let value as RZProtoValue: $0+>.x(value, .center)
            case let value as RZObservable<RZProtoValue>: $0+>.x(value, .center)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMaxX(){
        testFrameElement(\.maxX, "maxX"){
            switch $1{
            case let value as CGFloat: $0+>.x(value, .right)
            case let value as RZProtoValue: $0+>.x(value, .right)
            case let value as RZObservable<RZProtoValue>: $0+>.x(value, .right)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMinY(){
        testFrameElement(\.minY, "minY"){
            switch $1{
            case let value as CGFloat: $0+>.y(value)
            case let value as RZProtoValue: $0+>.y(value)
            case let value as RZObservable<RZProtoValue>: $0+>.y(value)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMidY(){
        testFrameElement(\.midY, "midY"){
            switch $1{
            case let value as CGFloat: $0+>.y(value, .center)
            case let value as RZProtoValue: $0+>.y(value, .center)
            case let value as RZObservable<RZProtoValue>: $0+>.y(value, .center)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testMaxY(){
        testFrameElement(\.maxY, "maxY"){
            switch $1{
            case let value as CGFloat: $0+>.y(value, .down)
            case let value as RZProtoValue: $0+>.y(value, .down)
            case let value as RZObservable<RZProtoValue>: $0+>.y(value, .down)
            default: XCTAssert(false, "No")
            }
            
        }
    }
    
    private static func testFrameElement(_ key: KeyPath<CGRect, CGFloat>, _ tag: String, _ setValue: (UIView, Any)->()){
        let frame = CGRect(origin: CGPoint(x: 10, y: 20), size: CGSize(width: 100, height: 200))
        let pView = UIView(frame: frame)
        let view = UIView()
        
        let value: CGFloat = 10
        testProtoValue(key, setValue(view, value), view, value, tag + " value")
        testProtoValue(key, setValue(view, pView*.h), view, pView.frame.height, tag + " protoValueNOb")
        testProtoValue(key, setValue(view, pView*.h + pView*.w), view, pView.frame.height + pView.frame.width, tag + " protoValueNOb h+w")
        testProtoValue(key, setValue(view, pView*.h + 30*), view, pView.frame.height + 30, tag + " protoValueNOb h+protoValueNOb")
        testProtoValue(key, setValue(view, pView*.h - pView*.w), view, pView.frame.height - pView.frame.width, tag + " protoValueNOb  h-w")
        testProtoValue(key, setValue(view, pView*.h - 30*), view, pView.frame.height - 30, tag + " protoValueNOb h-protoValueNOb")
        
        testProtoValue(key, setValue(view, pView*.h * pView*.w), view, pView.frame.height * pView.frame.width, tag + " protoValueNOb h*w")
        testProtoValue(key, setValue(view, pView*.h * 30*), view, pView.frame.height * 30, tag + " protoValueNOb h*protoValueNOb")
        testProtoValue(key, setValue(view, pView*.h / pView*.w), view, pView.frame.height / pView.frame.width, tag + " protoValueNOb h/w")
        testProtoValue(key, setValue(view, pView*.h / 30*), view, pView.frame.height / 30, tag + " protoValueNOb h/protoValueNOb")
        testProtoValue(key, setValue(view, 5 % pView*.h), view, pView.frame.height * 0.05, tag + " CGFloat % protoValueNOb")
        testProtoValue(key, setValue(view, 5* % pView*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb % protoValueNOb")
        
        
        testProtoValue(key, setValue(view, pView|*.h), view, pView.frame.height, tag + " protoValueOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoValue(key, setValue(view, pView|*.h + pView|*.w), view, pView.frame.height + pView.frame.width, tag + " protoValueOb h+w"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoValue(key, setValue(view, pView|*.h + 30*), view, pView.frame.height + 30, tag + " protoValueOb h+protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoValue(key, setValue(view, pView|*.h - pView|*.w), view, pView.frame.height - pView.frame.width, tag + " protoValueOb h-w"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoValue(key, setValue(view, pView|*.h - 30*), view, pView.frame.height - 30, tag + " protoValueOb h-protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoValue(key, setValue(view, pView|*.h * pView|*.w), view, pView.frame.height * pView.frame.width, tag + " protoValueOb h*w"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoValue(key, setValue(view, pView|*.h * 30*), view, pView.frame.height * 30, tag + " protoValueOb h*protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoValue(key, setValue(view, pView|*.h / pView|*.w), view, pView.frame.height / pView.frame.width, tag + " protoValueOb h/w"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoValue(key, setValue(view, pView|*.h / 30*), view, pView.frame.height / 30, tag + " protoValueOb h/protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoValue(key, setValue(view, 5 % pView|*.h), view, pView.frame.height * 0.05, tag + " CGFloat%protoValueOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        testProtoValue(key, setValue(view, 5* % pView|*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb%protoValueOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        var valueOb = RZObservable<CGFloat>(wrappedValue: 50.0)
        testProtoValue(key, setValue(view, valueOb.wrappedValue*), view, 50.0, tag + " protoValueOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 150.0)
        }
        
        testProtoValue(key, setValue(view, valueOb.wrappedValue* + 30*), view, 150.0 + 30, tag + " protoValueOb h+protoValueNOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 120.0)
        }
        
        testProtoValue(key, setValue(view, valueOb.wrappedValue* - 30*), view, 120.0 - 30, tag + " protoValueOb h-protoValueNOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 130.0)
        }
        
        testProtoValue(key, setValue(view, valueOb.wrappedValue* * 30*), view, 130.0 * 30, tag + " protoValueOb h*protoValueNOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 80.0)
        }
        
        testProtoValue(key, setValue(view, valueOb.wrappedValue* / 30*), view, 80.0 / 30, tag + " protoValueOb h/protoValueNOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 180.0)
        }
        
        testProtoValue(key, setValue(view, 5 % valueOb.wrappedValue*), view, 180.0 * 0.05, tag + " CGFloat%protoValueOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 100.0)
        }
        
        testProtoValue(key, setValue(view, 5* % valueOb.wrappedValue*), view, 100.0 * 0.05, tag + " protoValueNOb%protoValueOb"){
            valueOb = RZObservable<CGFloat>(wrappedValue: 110.0)
        }
    }
    
    static private func testProtoValue(
        _ key: KeyPath<CGRect, CGFloat>,
        _ action: @autoclosure ()->()?,
        _ view: UIView,
        _ expectedValue: @autoclosure ()->(CGFloat),
        _ message: String,
        _ changeValues: (()->())? = nil
    ){
        _ = action()
        XCTAssertEqual(view.frame[keyPath: key], expectedValue(), message)
        
        if let changeValues = changeValues{
            changeValues()
            XCTAssertEqual(view.frame[keyPath: key], expectedValue(), message)
        }
    }
    
}
