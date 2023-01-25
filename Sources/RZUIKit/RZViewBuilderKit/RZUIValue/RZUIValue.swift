//
//  RZUIValue.swift
//  Example
//
//  Created by Александр Сенин on 13.05.2022.
//

import UIKit
import RZObservableKit

public struct RZUIValue: RZUIValueProtocol{
    public private(set) var value = RZObservable<CGFloat>(wrappedValue: 0)
    public var isUpdatable: Bool { subValue != nil }
    private(set) var subValue: RZUIValueProtocol?
    
    public init(_ value: CGFloat){
        self.value.wrappedValue = value
    }
    
    public init(_ uiValue: RZUIValueProtocol){
        value = uiValue.value
        subValue = uiValue
    }
    
    public init(_ oResult: RZUIOperationValue.RZUIOperationResult){
        switch oResult{
            case .operation(let operation): self.init(operation)
            case .cgFloat(let value):       self.init(value)
        }
    }
}

extension RZUIValue{
    public static func +(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .addition))
    }
    
    public static func -(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .subtraction))
    }
    
    public static func *(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .multiplication))
    }
    
    public static func /(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .division))
    }
    
    
    public static func %(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .percent))
    }
    
    public static func %(left: CGFloat, right: RZUIValue) -> RZUIValue{
        return .init(left) % right
    }
    
    public static func -%(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .percent))
    }
    
    public static func -%(left: CGFloat, right: RZUIValue) -> RZUIValue{
        return .init(left) -% right
    }
    
    
    public static func <>(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .range))
    }
    public static func ><(left: RZUIValue, right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(left, right, opiration: .center))
    }
    public static prefix func -(right: RZUIValue) -> RZUIValue{
        .init(RZUIOperationValue.create(right, opiration: .reverse))
    }
}

extension RZUIValue: Comparable{
    public static func < (lhs: RZUIValue, rhs: RZUIValue) -> Bool {
        lhs.cgFloat < rhs.cgFloat
    }
    
    public static func == (lhs: RZUIValue, rhs: RZUIValue) -> Bool {
        lhs.cgFloat == rhs.cgFloat
    }
}


extension RZUIValue{
    public static func screen(
        _ orientation: ScreenOrientation = .vertical,
        _ value: (CGRect) -> (Self)
    ) -> Self{
        var bounds = UIScreen.main.bounds
        switch orientation {
        case .vertical:
            if bounds.width < bounds.height {break}
            bounds.size = CGSize(width: bounds.height, height: bounds.width)
        case .horizontal:
            if bounds.width > bounds.height {break}
            bounds.size = CGSize(width: bounds.height, height: bounds.width)
        default: break
        }
        return value(bounds)
    }
}
    
extension RZUIValue{
    @available(*, unavailable, message: "\n\nUse new syntax:\nlet view = UIView.build{$0\n\t.color(.white)\n\t.width(100).height($0*.w)\n}\n\nOr:\nlet view = UIView()\nview+>\n\t.color(.white)\n\t.width(100).height(view*.w)\n")
    public static func selfTag(value: RZProtoValue.RZProtoTag) -> Self{ return RZUIValue(0) }
    
    @available(*, deprecated, message: "\n\nOld:\t\t.screenTag(.w, .vertical)\nNew:\t.screen(.vertical){$0*.w}", renamed: "screen")
    public static func screenTag(
        _ value: RZProtoValue.RZProtoTag,
        _ orientation: ScreenOrientation = .vertical
    ) -> Self{
        .screen(orientation){.init(
            RZProtoValue.getValueAt(value, $0)
        )}
    }
}
