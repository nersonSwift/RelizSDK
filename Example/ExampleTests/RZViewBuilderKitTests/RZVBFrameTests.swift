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
    
    private static func testFrameElement(_ key: KeyPath<CGRect, CGFloat>, _ tag: String, _ setValue: (UIView, Any)->()){
        let frame = CGRect(origin: CGPoint(x: 10, y: 20), size: CGSize(width: 100, height: 200))
        let pView = UIView(frame: frame)
        let view = UIView()
        
        
        let value: CGFloat = 10
        view+>.height(value)
        XCTAssertEqual(view.frame.height, value, "value")
        
        testProtoHeightValue(key, setValue(view, pView*.h), view, pView.frame.height, tag + " protoValueNOb")
        
        testProtoHeightValue(key, setValue(view, pView*.h + pView*.w), view, pView.frame.height + pView.frame.width, tag + " protoValueNOb")
        testProtoHeightValue(key, setValue(view, pView*.h + 30*), view, pView.frame.height + 30, tag + " protoValueNOb")
        
        testProtoHeightValue(key, setValue(view, pView*.h - pView*.w), view, pView.frame.height - pView.frame.width, tag + " protoValueNOb")
        testProtoHeightValue(key, setValue(view, pView*.h - 30*), view, pView.frame.height - 30, tag + " protoValueNOb")
        
        testProtoHeightValue(key, setValue(view, pView*.h * pView*.w), view, pView.frame.height * pView.frame.width, tag + " protoValueNOb")
        testProtoHeightValue(key, setValue(view, pView*.h * 30*), view, pView.frame.height * 30, tag + " protoValueNOb")
        
        testProtoHeightValue(key, setValue(view, pView*.h / pView*.w), view, pView.frame.height / pView.frame.width, tag + " protoValueNOb")
        testProtoHeightValue(key, setValue(view, pView*.h / 30*), view, pView.frame.height / 30, tag + " protoValueNOb")
        
        testProtoHeightValue(key, setValue(view, 5 % pView*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb")
        testProtoHeightValue(key, setValue(view, 5* % pView*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb")
        
        
        
        testProtoHeightValue(key, setValue(view, pView|*.h), view, pView.frame.height, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoHeightValue(key, setValue(view, pView|*.h + pView|*.w), view, pView.frame.height + pView.frame.width, tag + " protoValueNOb"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoHeightValue(key, setValue(view, pView|*.h + 30*), view, pView.frame.height + 30, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoHeightValue(key, setValue(view, pView|*.h - pView|*.w), view, pView.frame.height - pView.frame.width, tag + " protoValueNOb"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoHeightValue(key, setValue(view, pView|*.h - 30*), view, pView.frame.height - 30, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoHeightValue(key, setValue(view, pView|*.h * pView|*.w), view, pView.frame.height * pView.frame.width, tag + " protoValueNOb"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoHeightValue(key, setValue(view, pView|*.h * 30*), view, pView.frame.height * 30, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoHeightValue(key, setValue(view, pView|*.h / pView|*.w), view, pView.frame.height / pView.frame.width, tag + " protoValueNOb"){
            pView.frame.size.height = 150
            pView.frame.size.width = 70
        }
        pView.frame = frame
        testProtoHeightValue(key, setValue(view, pView|*.h / 30*), view, pView.frame.height / 30, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        
        testProtoHeightValue(key, setValue(view, 5 % pView|*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
        testProtoHeightValue(key, setValue(view, 5* % pView|*.h), view, pView.frame.height * 0.05, tag + " protoValueNOb"){
            pView.frame.size.height = 150
        }
        pView.frame = frame
    }
    
    static private func testProtoHeightValue(
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
