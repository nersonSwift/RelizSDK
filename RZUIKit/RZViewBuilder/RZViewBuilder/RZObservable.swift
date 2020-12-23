//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation

@propertyWrapper
public class RZObservable<Value> {
    public var observeClosure: (Value)->() = {_ in}{
        didSet{
            observeClosure(wrappedValue)
        }
    }
    
    private var value: Value
    public var wrappedValue: Value{
        set(wrappedValue){
            value = wrappedValue
            observeClosure(wrappedValue)
        }
        get{
            value
        }
    }
    
    public init(wrappedValue: Value){
        self.value = wrappedValue
    }
}

public class RZSwith<Key: Hashable, Value>{
    var dictenary = [Key: Value]()
    
    init(_ key: Key, _ value: Value) {
        dictenary[key] = value
    }
    
    func add(_ value: (Key, Value)){
        dictenary[value.0] = value.1
    }
}

public func <|<Key: Hashable, Value>(left: (Key, Value), right: (Key, Value)) -> RZSwith<Key, Value>{
    RZSwith(left.0, left.1) <| right
}

public func <|<Key: Hashable, Value>(left: RZSwith<Key, Value>, right: (Key, Value)) -> RZSwith<Key, Value>{
    left.add(right)
    return left
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwith<Key, Value>) -> RZObservable<Value>?{
    guard let value = right.dictenary.first?.value else { return nil }
    let observable = RZObservable<Value>(wrappedValue: value)
    left.observeClosure = {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictenary[$0] else { return }
        observable.wrappedValue = value
    }
    objc_setAssociatedObject(left, "[\(arc4random())]", observable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return observable
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwith<Key, RZObservable<Value>>) -> RZObservable<Value>?{
    guard let value = right.dictenary.first else { return nil }
    let obValue = value.value.wrappedValue
    
    let observable = RZObservable<Value>(wrappedValue: obValue)
    var oldKey = value.key
    left.observeClosure = {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictenary[$0] else { return }
        guard let old = right.dictenary[oldKey] else { return }
        
        oldKey = $0
         
        old.observeClosure = {_ in}
        value.observeClosure = {[weak observable] in
            observable?.wrappedValue = $0
        }
    }
    objc_setAssociatedObject(left, "[\(arc4random())]", observable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return observable
}