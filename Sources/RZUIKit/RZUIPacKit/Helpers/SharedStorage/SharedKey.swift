//
//  SharedKey.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import Foundation

public protocol RZUIPacSharedKeyChainProtocol{}
public struct RZUIPacSharedKeyChain<T>: RZUIPacSharedKeyChainProtocol{ public init(){} }

public protocol RZUIPacSharedKeyProtocol: Hashable{
    var key: String { get }
}

extension RZUIPacSharedKeyProtocol{
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.key == rhs.key }
    public func hash(into hasher: inout Hasher) { key.hash(into: &hasher) }
}


public struct RZUIPacSharedKey<Chain: RZUIPacSharedKeyChainProtocol, Value>: RZUIPacSharedKeyProtocol{
    public var key: String { "\(Chain.self)" + keyString + "\(Value.self)" }
    private var keyString: String
    
    public init(chain: Chain.Type = Chain.self, type: Value.Type = Value.self, key: String) {
        self.keyString = key
    }
}
