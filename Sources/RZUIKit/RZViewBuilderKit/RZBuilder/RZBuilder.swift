//
//  RZBuilder.swift
//  Example
//
//  Created by Александр Сенин on 09.05.2023.
//

import Foundation

public class RZBuilder<V: RZBuildableProtocol>: RZBuilderProtocol{
    public private(set) var value: V
    required public init(_ value: V){
        self.value = value
    }
}

