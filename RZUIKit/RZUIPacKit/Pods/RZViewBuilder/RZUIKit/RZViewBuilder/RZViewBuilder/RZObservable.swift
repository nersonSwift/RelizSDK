//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation
import SwiftUI
import Combine

extension ObservableObject{
    func rzObservable<T>(
        _ bindingKey: KeyPath<ObservedObject<Self>.Wrapper, Binding<T>>,
        _ publisherKey: KeyPath<Self, Published<T>.Publisher>
    ) -> RZObservable<T>
    {
        let key = "\(bindingKey)\(publisherKey)"
        
        if let rzObservable = getAssociated(key.hashValue) as? RZObservable<T>{return rzObservable }
        
        let binding = ObservedObject(initialValue: self).projectedValue[keyPath: bindingKey]
        let rzObservable = RZPublisherObservable(binding: binding)
        
        rzObservable.anyCancellable = self[keyPath: publisherKey].sink {[weak rzObservable] value in
            rzObservable?.update(value)
        }
        
        setAssociated(key.hashValue, rzObservable)
        return rzObservable
    }
    
    private func setAssociated(_ int: Int, _ obj: Any){
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: int)!, obj, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getAssociated(_ int: Int) -> Any?{
        objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: int)!)
    }
    
    public func setRZObservables(){
        let mirror = Mirror(reflecting: self)
        for cild in mirror.children{
            (cild.value as? RZObservableProtocol)?.objectWillChange = objectWillChange as? ObservableObjectPublisher
        }
    }
}

public protocol RZObservableProtocol: class {
    var objectWillChange: ObservableObjectPublisher? {get set}
}

@propertyWrapper
public class RZObservable<Value>: RZObservableProtocol {
    var observeClosures = [Int: (Value)->()]()
    var counter: Int = 0
    public var objectWillChange: ObservableObjectPublisher?
    
    @discardableResult
    public func add(_ observeClosure: @escaping (Value)->()) -> Int{
        observeClosure(wrappedValue)
        observeClosures[counter] = observeClosure
        counter += 1
        return counter - 1
    }
    public func remove(_ key: Int){
        observeClosures[key] = nil
    }
    
    var value: Value{
        didSet{
            objectWillChange?.send()
        }
    }
    public var wrappedValue: Value{
        set(wrappedValue){
            value = wrappedValue
            observeClosures.forEach{ $0.value(wrappedValue) }
        }
        get{
            value
        }
    }
    
    public var projectedValue: RZObservable<Value> {return self}
    
    public init(wrappedValue: Value){
        self.value = wrappedValue
    }
}

public class RZPublisherObservable<Value>: RZObservable<Value>{
    public var binding: Binding<Value>?
    public var anyCancellable: AnyCancellable?
    
    override public var wrappedValue: Value{
        set(wrappedValue){
            if let binding = binding{
                binding.wrappedValue = wrappedValue
            }else{
                super.wrappedValue = wrappedValue
            }
        }
        get{
            value
        }
    }
    
    public func update(_ value: Value){
        self.value = value
        self.observeClosures.forEach{ $0.value(self.value) }
    }
    
    public init(binding: Binding<Value>){
        super.init(wrappedValue: binding.wrappedValue)
        self.binding = binding
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
    left.add {[weak observable] in
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
    var oldClosureKey = -1
    left.add {[weak observable] in
        guard let observable = observable else { return }
        guard let value = right.dictenary[$0] else { return }
        guard let old = right.dictenary[oldKey] else { return }
        
        old.remove(oldClosureKey)
        oldKey = $0
        oldClosureKey = value.add {[weak observable] in
            observable?.wrappedValue = $0
        }
    }
    objc_setAssociatedObject(left, "[\(arc4random())]", observable, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return observable
}
