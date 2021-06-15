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
        testMinY()
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
    
    private static func testMinY(){
        testFrameElement(\.minX, "minY"){
            switch $1{
            case let value as CGFloat: $0+>.y(value)
            case let value as RZProtoValue: $0+>.y(value)
            case let value as RZObservable<RZProtoValue>: $0+>.y(value)
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
        
        switch key {
        case \.height:
            testProtoValue(key, setValue(view, pView*.h), view, pView.frame.height, tag + " protoValueNOb")
            testProtoValue(key, setValue(view, pView*.h + 30*), view, pView.frame.height + 30, tag + " protoValueNOb h+protoValueNOb")
            testProtoValue(key, setValue(view, pView*.h - pView*.w), view, pView.frame.height - pView.frame.width, tag + " protoValueNOb  h-w")
            testProtoValue(key, setValue(view, pView*.h - 30*), view, pView.frame.height - 30, tag + " protoValueNOb h-protoValueNOb")
            testProtoValue(key, setValue(view, pView*.h * 30*), view, pView.frame.height * 30, tag + " protoValueNOb h*protoValueNOb")
            testProtoValue(key, setValue(view, pView*.h / pView*.w), view, pView.frame.height / pView.frame.width, tag + " protoValueNOb h/w")
            testProtoValue(key, setValue(view, pView*.h / 30*), view, pView.frame.height / 30, tag + " protoValueNOb h/protoValueNOb")
            testProtoValue(key, setValue(view, 5 % pView*.h), view, pView.frame.height * 0.05, tag + " CGFloat % protoValueNOb")
            testProtoValue(key, setValue(view, 5* % pView*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb % protoValueNOb")
        case \.width:
            testProtoValue(key, setValue(view, pView*.w), view, pView.frame.width, tag + " protoValueNOb")
            testProtoValue(key, setValue(view, pView*.w + 30*), view, pView.frame.width + 30, tag + " protoValueNOb h+protoValueNOb")
            print(pView*.w - pView*.h)
            print(pView.frame.width - pView.frame.height)
            testProtoValue(key, setValue(view, pView*.w - pView*.h), view, pView.frame.width - pView.frame.height, tag + " protoValueNOb  w-h")
            testProtoValue(key, setValue(view, pView*.w - 30*), view, pView.frame.width - 30, tag + " protoValueNOb w-protoValueNOb")
            testProtoValue(key, setValue(view, pView*.w * 30*), view, pView.frame.width * 30, tag + " protoValueNOb w*protoValueNOb")
            testProtoValue(key, setValue(view, pView*.w / pView*.h), view, pView.frame.width / pView.frame.height, tag + " protoValueNOb w/h")
            testProtoValue(key, setValue(view, pView*.w / 30*), view, pView.frame.width / 30, tag + " protoValueNOb w/protoValueNOb")
            testProtoValue(key, setValue(view, 5 % pView*.w), view, pView.frame.width * 0.05, tag + " CGFloat % protoValueNOb")
            testProtoValue(key, setValue(view, 5* % pView*.w), view, pView.frame.width * 0.05, tag + " protoValueNOb % protoValueNOb")
        case \.minX:
            testProtoValue(key, setValue(view, pView*.x), view, pView.frame.minX, tag + " protoValueNOb")
            testProtoValue(key, setValue(view, pView*.x + pView*.mY), view, pView.frame.minX + pView.frame.maxY, tag + " protoValueNOb x+mY")
            testProtoValue(key, setValue(view, pView*.x + 30*), view, pView.frame.minX + 30, tag + " protoValueNOb+protoValueNOb")
            testProtoValue(key, setValue(view, pView*.x - pView*.y), view, pView.frame.minX - pView.frame.minY, tag + " protoValueNOb  x-y")
            testProtoValue(key, setValue(view, pView*.x - 30*), view, pView.frame.minX - 30, tag + " protoValueNOb x-protoValueNOb")
            testProtoValue(key, setValue(view, pView*.x * pView*.mY), view, pView.frame.minX * pView.frame.maxY, tag + " protoValueNOb x*mY")
            testProtoValue(key, setValue(view, pView*.x * 30*), view, pView.frame.minX * 30, tag + " protoValueNOb x*protoValueNOb")
            testProtoValue(key, setValue(view, pView*.x / pView*.y), view, pView.frame.minX / pView.frame.minY, tag + " protoValueNOb x/y")
            testProtoValue(key, setValue(view, pView*.x / pView*.mY), view, pView.frame.minX / pView.frame.maxY, tag + " protoValueNOb x/mY")
            testProtoValue(key, setValue(view, pView*.x / 30*), view, pView.frame.minX / 30, tag + " protoValueNOb x/protoValueNOb")
            testProtoValue(key, setValue(view, 5 % pView*.x), view, pView.frame.minX * 0.05, tag + " CGFloat % protoValueNOb")
            testProtoValue(key, setValue(view, 5* % pView*.x), view, pView.frame.minX * 0.05, tag + " protoValueNOb % protoValueNOb")
        case \.minY:
            testProtoValue(key, setValue(view, pView*.y), view, pView.frame.minY, tag + " protoValueNOb")
            testProtoValue(key, setValue(view, pView*.y + pView*.mX), view, pView.frame.minY + pView.frame.maxX, tag + " protoValueNOb y+mX")
            testProtoValue(key, setValue(view, pView*.y + 30*), view, pView.frame.minY + 30, tag + " protoValueNOb+protoValueNOb")
            testProtoValue(key, setValue(view, pView*.y - pView*.x), view, pView.frame.minY - pView.frame.minX, tag + " protoValueNOb  y-x")
            testProtoValue(key, setValue(view, pView*.y - 30*), view, pView.frame.minY - 30, tag + " protoValueNOb y-protoValueNOb")
            testProtoValue(key, setValue(view, pView*.y * pView*.mX), view, pView.frame.minY * pView.frame.maxX, tag + " protoValueNOb y*mX")
            testProtoValue(key, setValue(view, pView*.y * 30*), view, pView.frame.minY * 30, tag + " protoValueNOb y*protoValueNOb")
            testProtoValue(key, setValue(view, pView*.y / pView*.x), view, pView.frame.minY / pView.frame.minX, tag + " protoValueNOb y/x")
            testProtoValue(key, setValue(view, pView*.y / pView*.mX), view, pView.frame.minY / pView.frame.maxX, tag + " protoValueNOb y/mX")
            testProtoValue(key, setValue(view, pView*.y / 30*), view, pView.frame.minY / 30, tag + " protoValueNOb y/protoValueNOb")
            testProtoValue(key, setValue(view, 5 % pView*.y), view, pView.frame.minY * 0.05, tag + " CGFloat % protoValueNOb")
            testProtoValue(key, setValue(view, 5* % pView*.y), view, pView.frame.minY * 0.05, tag + " protoValueNOb % protoValueNOb")
        default:
            print("Default")
        }
        
        if key == \.minX || key == \.minY {
            testProtoValue(key, setValue(view, pView*.x + pView*.y), view, pView.frame.minX + pView.frame.minY, tag + " protoValueNOb x+y")
            testProtoValue(key, setValue(view, pView*.x * pView*.y), view, pView.frame.minX * pView.frame.minY, tag + " protoValueNOb x*y")
        } else if key == \.height || key == \.width {
            testProtoValue(key, setValue(view, pView*.h + pView*.w), view, pView.frame.height + pView.frame.width, tag + " protoValueNOb h+w")
            testProtoValue(key, setValue(view, pView*.h * pView*.w), view, pView.frame.height * pView.frame.width, tag + " protoValueNOb h*w")
        }
        

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
    }
    
    static private func testProtoValue(
        _ key: KeyPath<CGRect, CGFloat>,
        _ action: @autoclosure ()->(),
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
