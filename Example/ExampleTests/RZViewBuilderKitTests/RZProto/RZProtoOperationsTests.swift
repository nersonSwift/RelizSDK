//
//  RZProtoOperationsTests.swift
//  ExampleTests
//
//  Created by Valeriya Tarasenko on 29.06.2021.
//

import XCTest
@testable import RelizKit
@testable import RZViewBuilderKit

class RZProtoOperationsTests: TestProtocol{
    static func test(){
        //MARK: - %
        //MARK: - CGFloat ProtoValue
        let value: CGFloat = 15
        let protoValue: RZProtoValue = value*
        let procent = value % protoValue
        XCTAssertEqual(protoValue.getValue() * 0.15, procent.getValue(), "CGFloat % ProtoValue")
        
        //MARK: - ProtoValue ProtoValue
        let protoProcent = protoValue % protoValue
        XCTAssertEqual(protoValue.getValue() * 0.15, protoProcent.getValue(), "ProtoValue % ProtoValue")
        
        //MARK: - +
        //MARK: - ProtoValue ProtoValue
        let protoPlus = protoValue + protoValue
        XCTAssertEqual(protoPlus.getValue(), protoValue.getValue() + protoValue.getValue(), "ProtoValue + ProtoValue")
        
        //MARK: - -
        //MARK: - ProtoValue ProtoValue
        let protoMinus = protoValue - protoValue
        XCTAssertEqual(protoMinus.getValue(), protoValue.getValue() - protoValue.getValue(), "ProtoValue - ProtoValue")
        
        //MARK: - /
        //MARK: - ProtoValue ProtoValue
        let protoDivision = protoValue / protoValue
        XCTAssertEqual(protoDivision.getValue(), protoValue.getValue() / protoValue.getValue(), "ProtoValue / ProtoValue")
        
        //MARK: - *
        //MARK: - ProtoValue ProtoValue
        let protoMultiplication = protoValue * protoValue
        XCTAssertEqual(protoMultiplication.getValue(), protoValue.getValue() * protoValue.getValue(), "ProtoValue * ProtoValue")
        
        //MARK: - <>
        //MARK: - ProtoValue ProtoValue
        let view = UIView()+>.width(10).height(50).x(120).y(64).view
        let view1 = UIView()+>.width(10).height(50).x(39).y(164).view
        
        let protoDistance = view1*.mX <> view*.x
        XCTAssertEqual(protoDistance.getValue(), (view*.x - view1*.mX).getValue(), "ProtoValue <> ProtoValue")
        
        //MARK: - ><
        //MARK: - ProtoValue ProtoValue
        let protoCenter = view1*.mX >< view*.x
        XCTAssertEqual(protoCenter.getValue(), (view*.x - view1*.mX).getValue() / 2 + view1*.mX.getValue(), "ProtoValue >< ProtoValue")
        
        //MARK: - prefix -
        //MARK: - ProtoValue
        let prefix = -protoValue
        XCTAssertEqual(prefix.getValue(), -(protoValue.getValue()), "-ProtoValue")
    }
}
