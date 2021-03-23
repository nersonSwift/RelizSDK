//
//  ObservableObjectExtension.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import SwiftUI
import Combine

extension ObservableObject{
    public func rzObservable<T>(
        _ bindingKey: KeyPath<ObservedObject<Self>.Wrapper, Binding<T>>,
        _ publisherKey: KeyPath<Self, Published<T>.Publisher>
    ) -> RZObservable<T>
    {
        let key = "\(bindingKey)\(publisherKey)"
        
        if let rzObservable = getAssociated(key) as? RZObservable<T>{return rzObservable }
        
        let binding = ObservedObject(initialValue: self).projectedValue[keyPath: bindingKey]
        let rzObservable = RZPublisherObservable(binding: binding)
        
        rzObservable.anyCancellable = self[keyPath: publisherKey].sink {[weak rzObservable] value in
            rzObservable?.update(value)
        }
        
        setAssociated(key, rzObservable)
        return rzObservable
    }
    
    private func setAssociated(_ key: String, _ obj: Any){
        Associated(self).set(obj, .hashable(key), .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func getAssociated(_ key: String) -> Any?{
        Associated(self).get(.hashable(key))
    }
    
    public func setRZObservables(){
        let mirror = Mirror(reflecting: self)
        for cild in mirror.children{
            (cild.value as? RZObservableProtocol)?.objectWillChange = objectWillChange as? ObservableObjectPublisher
        }
    }
}
