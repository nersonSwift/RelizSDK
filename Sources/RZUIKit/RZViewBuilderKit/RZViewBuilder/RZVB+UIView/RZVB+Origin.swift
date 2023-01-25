//
//  RZVB+Origin.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//
import Foundation
import RZObservableKit

extension RZViewBuilder{
    public enum XType: String{
        case center
        case left
        case right
    }
    
    //MARK: - х
    static func _x(_ view: UIView, _ value: CGFloat,  _ type: XType = .left){
        switch type {
            case .left:   view.frame.origin.x = value
            case .right:  view.frame.origin.x = value - view.frame.width
            case .center: view.center.x = value
        }
    }
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавливаемый х
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
    @discardableResult
    public func x(_ value: CGFloat,  _ type: XType = .left) -> Self{
        let action: (V, CGFloat)->() = { view, value in
            Self._x(view, value)
        }
        uiUpdate(tag: .x, value: value, closure: action)
        uiUpdate(priority: .medium, tag: .x, value: RZUIValue(RZUIValueObservableWrapper(view.rzWidth)), useNow: false, observer: .add, closure: action)
        return self
    }
    /// `RU: - `
    /// Устанавливает х view
    ///
    /// - Parameter value
    /// Устанавливаемый х в виде вычисляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.left`
    @discardableResult
    public func x(_ value: RZUIValue, _ type: XType = .left) -> Self{
        let action: (V, CGFloat)->() = { view, value in
            Self._x(view, value)
        }
        uiUpdate(priority: .medium, tag: .x, value: value, closure: action)
        uiUpdate(priority: .medium, tag: .x, value: RZUIValue(RZUIValueObservableWrapper(view.rzWidth)), useNow: false, observer: .add, closure: action)
        return self
    }
    
    public enum YType: String{
        case center
        case top
        case down
    }
    
    //MARK: - y
    static func _y(_ view: UIView, _ value: CGFloat,  _ type: YType = .top){
        switch type {
            case .top:    view.frame.origin.y = value
            case .down:   view.frame.origin.y = value - view.frame.height
            case .center: view.center.y = value
        }
    }
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавливаемый y
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
    @discardableResult
    public func y(_ value: CGFloat,  _ type: YType = .top) -> Self{
        let action: (V, CGFloat)->() = { view, value in
            Self._y(view, value)
        }
        uiUpdate(tag: .y, value: value, closure: action)
        uiUpdate(priority: .medium, tag: .y, value: RZUIValue(RZUIValueObservableWrapper(view.rzHeight)), useNow: false, observer: .add, closure: action)
        return self
    }
    
    /// `RU: - `
    /// Устанавливает y view
    ///
    /// - Parameter value
    /// Устанавливаемый в виде вычисляемого `RZProtoValue`
    ///
    /// - Parameter type
    /// Точка крепления view по умолчанию `.top`
    @discardableResult
    public func y(_ value: RZUIValue, _ type: YType = .top) -> Self{
        let action: (V, CGFloat)->() = { view, value in
            Self._y(view, value)
        }
        uiUpdate(priority: .medium, tag: .y, value: value, closure: action)
        uiUpdate(priority: .medium, tag: .y, value: RZUIValue(RZUIValueObservableWrapper(view.rzHeight)), useNow: false, observer: .add, closure: action)
        return self
    }
}
