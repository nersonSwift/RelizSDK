//
//  SharedKey.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import Foundation

public struct RZUIPacSharedKeyChain<T>{ public init(){} }

public protocol RZUIPacSharedKeyProtocol: Hashable{
    var key: String { get }
}

extension RZUIPacSharedKeyProtocol{
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.key == rhs.key }
    public func hash(into hasher: inout Hasher) { key.hash(into: &hasher) }
}


public struct RZUIPacSharedKey<T>: RZUIPacSharedKeyProtocol{
    public var key: String { keyString + "\(T.self)" }
    private var keyString: String
    
    public init(type: T.Type = T.self, key: String) {
        self.keyString = key
    }
}
