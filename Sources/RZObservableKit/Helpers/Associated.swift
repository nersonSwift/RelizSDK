//
//  Associated.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import Foundation

public struct Associated{
    public enum SetKey {
        case random
        case hashable(AnyHashable)
        case pointer(UnsafeRawPointer)
    }
    
    private weak var object: AnyObject?
    
    public init(_ object: AnyObject){ self.object = object }
    
    @discardableResult
    public func set(_ value: Any?, _ key: SetKey, _ policy: objc_AssociationPolicy) -> SetKey? {
        guard let object = object else {return nil}
        let key = getKey(key)
        objc_setAssociatedObject(object, key, value, policy)
        return .pointer(key)
    }
    
    public func get(_ key: SetKey) -> Any?{
        guard let object = object else {return nil}
        let key = getKey(key)
        return objc_getAssociatedObject(object, key)
    }
    
    private func getKey(_ key: SetKey) -> UnsafeRawPointer{
        var pointerKey: UnsafeRawPointer
        
        switch key {
        case .random:
            var pointer: UnsafeRawPointer?
            repeat{
                pointer = UnsafeRawPointer(bitPattern: Int(arc4random()))
            }while pointer == nil
            pointerKey = pointer!
        case .hashable(let anyHashable):
            pointerKey = UnsafeRawPointer(bitPattern: anyHashable.hashValue)!
        case .pointer(let pointer):
            pointerKey = pointer
        }
        
        return pointerKey
    }
}
