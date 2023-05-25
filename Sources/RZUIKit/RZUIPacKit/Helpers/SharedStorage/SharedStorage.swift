//
//  RZUIPacSharedStorage.swift
//  Example
//
//  Created by Александр Сенин on 25.05.2023.
//

import Foundation

public struct RZUIPacSharedStorage{
    private var storage = [String: Any]()
    
    public subscript<T>(_ key: RZUIPacSharedKey<T>) -> T? {
        set(value){ storage[key.key] = value }
        get{ storage[key.key] as? T }
    }
    
    public init(){}
    public init(_ controls: [RZUIPacSharedContainer]){ append(controls: controls) }
    public init<T>(key: RZUIPacSharedKey<T>, value: T){ append(key: key, value: value) }
    
    public mutating func append<T>(key: RZUIPacSharedKey<T>, value: T){
        self[key] = value
    }
    
    public mutating func append(controls: [RZUIPacSharedContainer]){
        controls.forEach { storage[$0.key.key] = $0.value }
    }
    
    public static func +(lhs: Self, rhs: Self?) -> Self{
        var new = lhs
        new += rhs
        return new
    }
    
    public static func +=(lhs: inout Self, rhs: Self?){
        rhs?.storage.forEach{ lhs.storage[$0.key] = $0.value }
    }
}

public struct RZUIPacSharedContainer{
    private(set) var key: any RZUIPacSharedKeyProtocol
    private(set) var value: Any
    
    public init<T>(key: RZUIPacSharedKey<T>, value: T){
        self.key = key
        self.value = value
    }
}
