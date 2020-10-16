//
//  Operators.swift
//  RelizKit
//
//  Created by Александр Сенин on 17.10.2020.
//

import UIKit


postfix operator +>
postfix operator *

public postfix func +><V: UIView>(view: V) -> RZViewBuilder<V>{
    RZViewBuilder(view)
}

public postfix func *(value: UIView) -> RZProto{
    RZProto(value)
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
