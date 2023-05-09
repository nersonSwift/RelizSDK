//
//  Operators.swift
//  RelizKit
//
//  Created by Александр Сенин on 17.10.2020.
//

import UIKit
import RZObservableKit


postfix operator +>
postfix operator *
postfix operator |*

infix operator <>
infix operator ><

precedencegroup SecondTernaryPrecedence {
    associativity: right
}

precedencegroup FirstTernaryPrecedence {
    associativity: left
    higherThan: SecondTernaryPrecedence
}

infix operator ?> : SecondTernaryPrecedence
infix operator <| : FirstTernaryPrecedence

public postfix func +><V: UIView>(view: V) -> RZBuilder<V>{ view.builder }

public postfix func *<B: RZBuilderProtocol>(value: B) -> RZProto where B.V: UIView{
    RZProto(value.value)
}

public postfix func |*<B: RZBuilderProtocol>(value: B) -> RZProto where B.V: UIView{
    RZProto(value.value, true)
}

public postfix func *(value: UIView) -> RZProto{
    RZProto(value)
}

public postfix func |*(value: UIView) -> RZProto{
    RZProto(value, true)
}

public postfix func *(value: CGRect) -> RZProto{
    RZProto(value)
}

public postfix func *(value: CGSize) -> RZProto{
    RZProto(value)
}

public postfix func *(value: CGPoint) -> RZProto{
    RZProto(value)
}

public postfix func *(value: CGFloat) -> RZProtoValue{
    .value(value)
}

public postfix func *(value: RZObservable<RZProtoValue>) -> RZProtoValue{
    var proto = RZProtoValue()
    proto.operation = RZProtoOperation(value, .wrap)
    return proto
}

public postfix func *(value: RZObservable<CGFloat>) -> RZProtoValue{
    var proto = RZProtoValue()
    proto.operation = RZProtoOperation(value, .wrap)
    return proto
}

