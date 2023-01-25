//
//  RZVB+uiUpdate.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    enum ObserverAnchorAction{
        case add
        case update
    }
    
    @discardableResult
    func uiUpdate(
        priority: RZUIQueue.Priority = .low,
        tag: RZObserveController.Tag,
        value: RZUIValue,
        useNow: Bool = true,
        observer: ObserverAnchorAction = .update,
        closure: @escaping (V, CGFloat)->()
    ) -> Self{
        if value.isUpdatable {
            uiUpdate(priority: priority, tag: tag, value: value.value, closure: closure)
        }else{
            uiUpdate(tag: tag, value: value.cgFloat, closure: closure)
        }
        return self
    }
    
    @discardableResult
    func uiUpdate<T>(
        priority: RZUIQueue.Priority = .low,
        tag: RZObserveController.Tag,
        value: RZObservable<T>,
        useNow: Bool = true,
        observer: ObserverAnchorAction = .update,
        closure: @escaping (V, T)->()
    ) -> Self{
        let result = value.add {[weak view] value in
            RZUIQueue.main.add(priority: priority, tag: tag, view: view ?? UIView()) { view in
                closure((view as? V) ?? V(), value.new)
            }
        }
        if observer == .update{
            view.observeController.set(tag, result)
        }else{
            view.observeController.add(tag, result)
        }
        return self
    }
    
    @discardableResult
    func uiUpdate<T>(
        tag: RZObserveController.Tag? = nil,
        value: T,
        closure: @escaping (V, T)->()
    ) -> Self{
        if let tag = tag{ view.observeController.remove(tag) }
        closure(view, value)
        return self
    }
}
