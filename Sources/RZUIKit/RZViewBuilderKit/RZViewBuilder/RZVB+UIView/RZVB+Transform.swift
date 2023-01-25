//
//  RZVB+Transform.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 23.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    static func _tx(_ view: V, _ value: CGFloat){
        view.transform.tx = value
    }
    
    @discardableResult
    public func tx(_ value: CGFloat) -> Self{
        uiUpdate(tag: .tx, value: value) { view, value in
            Self._tx(view, value)
        }
    }
    
    @discardableResult
    public func tx(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .tx, value: value) { view, value in
            Self._tx(view, value)
        }
    }
    
    
    static func _ty(_ view: V, _ value: CGFloat){
        view.transform.ty = value
    }
    @discardableResult
    public func ty(_ value: CGFloat) -> Self{
        uiUpdate(tag: .ty, value: value) { view, value in
            Self._ty(view, value)
        }
    }
    @discardableResult
    public func ty(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .ty, value: value) { view, value in
            Self._ty(view, value)
        }
    }
    
    static func _ta(_ view: V, _ value: CGFloat){
        view.transform.a = value
    }
    @discardableResult
    public func ta(_ value: CGFloat) -> Self{
        uiUpdate(tag: .ta, value: value) { view, value in
            Self._ta(view, value)
        }
    }
    
    @discardableResult
    public func ta(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .ta, value: value) { view, value in
            Self._ta(view, value)
        }
    }
    
    ///
    
    static func _tb(_ view: V, _ value: CGFloat){
        view.transform.b = value
    }
    @discardableResult
    public func tb(_ value: CGFloat) -> Self{
        uiUpdate(tag: .tb, value: value) { view, value in
            Self._tb(view, value)
        }
    }
    @discardableResult
    public func tb(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .tb, value: value) { view, value in
            Self._tb(view, value)
        }
    }
    
    ///
    
    static func _tc(_ view: V, _ value: CGFloat){
        view.transform.c = value
    }
    @discardableResult
    public func tc(_ value: CGFloat) -> Self{
        uiUpdate(tag: .tc, value: value) { view, value in
            Self._tc(view, value)
        }
    }
    @discardableResult
    public func tc(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .tc, value: value) { view, value in
            Self._tc(view, value)
        }
    }
    
    ///
    
    static func _td(_ view: V, _ value: CGFloat){
        view.transform.d = value
    }
    @discardableResult
    public func td(_ value: CGFloat) -> Self{
        uiUpdate(tag: .td, value: value) { view, value in
            Self._td(view, value)
        }
    }
    @discardableResult
    public func td(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .td, value: value) { view, value in
            Self._td(view, value)
        }
    }
    
    static func _transform(_ view: V, _ value: CGAffineTransform){
        view.transform = value
    }
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self{
        uiUpdate(tag: .transform, value: value) { view, value in
            Self._transform(view, value)
        }
    }
    @discardableResult
    public func transform(_ value: RZObservable<CGAffineTransform>?) -> Self{
        guard let value = value else { return self }
        uiUpdate(tag: .td, value: value) { view, value in
            Self._transform(view, value)
        }
    }
}
