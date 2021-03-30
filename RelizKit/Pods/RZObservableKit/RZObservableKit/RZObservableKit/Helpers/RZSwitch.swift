//
//  RZSwith.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import Foundation

public class RZSwitch<Key: Hashable, Value>{
    var dictionary = [Key: Value]()
    
    init(_ key: Key, _ value: Value) {
        dictionary[key] = value
    }
    init(_ dictionary: [Key: Value]){
        self.dictionary = dictionary
    }
    
    func add(_ value: (Key, Value)){
        dictionary[value.0] = value.1
    }
}

public func <|<Key: Hashable, Value>(left: (Key, Value), right: (Key, Value)) -> RZSwitch<Key, Value>{
    RZSwitch(left.0, left.1) <| right
}

public func <|<Key: Hashable, Value>(left: RZSwitch<Key, Value>, right: (Key, Value)) -> RZSwitch<Key, Value>{
    left.add(right)
    return left
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwitch<Key, Value>) -> RZObservable<Value>?{
    guard let value = right.dictionary.first?.value else { return nil }
    let observable = RZObservable<Value>(wrappedValue: value)
    let obj = left.add {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictionary[$0.new] else { return }
        observable.setValue($0.useType, value: value)
    }
    let key = -obj.key
    obj.use(.noAnimate)
    Associated(left).set(observable, .hashable(key), .OBJC_ASSOCIATION_RETAIN)
    return observable
}

public func ?><Key: Hashable, Value>(left: RZObservable<Key>, right: RZSwitch<Key, RZObservable<Value>>) -> RZObservable<Value>?{
    guard let value = right.dictionary.first else { return nil }
    let obValue = value.value.wrappedValue
    
    let observable = RZObservable<Value>(wrappedValue: obValue)
    var oldKey = value.key
    var oldClosureKey = -1
    let obj = left.add {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictionary[$0.new] else { return }
        guard let old = right.dictionary[oldKey] else { return }
        
        old.remove(oldClosureKey)
        oldKey = $0.new
        oldClosureKey = value.add {[weak observable] in
            observable?.setValue($0.useType, value: $0.new)
        }.key
    }
    let key = -obj.key
    obj.use(.noAnimate)
    Associated(left).set(observable, .hashable(key), .OBJC_ASSOCIATION_RETAIN)
    return observable
}
