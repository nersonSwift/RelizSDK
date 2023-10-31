//
//  RZBuildable.swift
//  Example
//
//  Created by Александр Сенин on 09.05.2023.
//

import Foundation

public protocol RZBuildableProtocol{
    init()
}

extension RZBuildableProtocol{
    @discardableResult
    public static func build<B: RZBuilderProtocol>(_ type: B.Type, _ closure: (B) -> ()) -> Self where B.V == Self{
        Self.init().build(type, closure)
    }

    @discardableResult
    public func build<B: RZBuilderProtocol>(_ type: B.Type, _ closure: (B) -> ()) -> Self where B.V == Self{
        closure(B.init(self))
        return self
    }
}

extension RZBuildableProtocol{
    public var builder: RZBuilder<Self> { .init(self) }

    @discardableResult
    public static func build(_ closure: (RZBuilder<Self>) -> ()) -> Self{
        Self.init().build(closure)
    }

    @discardableResult
    public func build(_ closure: (RZBuilder<Self>) -> ()) -> Self{
        closure(builder)
        return self
    }
}
