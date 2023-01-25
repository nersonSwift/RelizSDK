//
//  RZVB+Template.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    //MARK: - template
    static func _template(_ view: V, _ value: RZVBTemplate<V>){
        value.use(view: view)
    }
    
    @discardableResult
    public func template(_ value: RZVBTemplate<V>) -> Self{
        uiUpdate(value: value) { view, value in
            Self._template(view, value)
        }
    }
    @discardableResult
    public func template(_ value: RZObservable<RZVBTemplate<V>>?, _ useNow: Bool = true) -> Self{
        guard let value = value else {return self}
        return uiUpdate(tag: .custom("template"), value: value, useNow: useNow, observer: .add) { view, value in
            Self._template(view, value)
        }
    }
    @discardableResult
    public func template(_ value: (V)->()) -> Self{
        value(view)
        return self
    }
    @discardableResult
    public func template(_ values: [RZVBTemplate<V>]) -> Self{
        values.forEach{template($0)}
        return self
    }
    @discardableResult
    public func template(_ values: RZVBTemplate<V>...) -> Self{
        values.forEach{template($0)}
        return self
    }
    @discardableResult
    public func template(@ArrayBuilder _ values: ()->[RZVBTemplate<V>]) -> Self{
        template(values())
        return self
    }
}
