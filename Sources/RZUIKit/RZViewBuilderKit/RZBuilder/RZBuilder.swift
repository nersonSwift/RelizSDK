//
//  RZBuilder.swift
//  Example
//
//  Created by Александр Сенин on 09.05.2023.
//

import Foundation

public protocol RZBuilderProtocol{
    associatedtype V: RZBuildable
    
    init(_ value: V)
}

public class RZBuilder<V: RZBuildable>: RZBuilderProtocol{
    public private(set) var value: V
    required public init(_ value: V){
        self.value = value
    }
}

public class RZBuilder1<V: RZBuildable>: RZBuilderProtocol{
    public private(set) var value: V
    public var hello = 10
    required public init(_ value: V){
        self.value = value
    }
}
