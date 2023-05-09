//
//  RZBuilderProtocol.swift
//  Example
//
//  Created by Александр Сенин on 09.05.2023.
//

import Foundation

public protocol RZBuilderProtocol{
    associatedtype V: RZBuildableProtocol
    
    init(_ value: V)
}
