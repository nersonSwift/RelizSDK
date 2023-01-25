//
//  RZVB+Size.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    static func _width(_ view: UIView, _ value: CGFloat){
        view.frame.size.width = value
        RZLabelSizeController.modUpdate(view, true)
    }
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина
    @discardableResult
    public func width(_ value: CGFloat) -> Self{
        uiUpdate(tag: .width, value: value) { view, value in
            Self._width(view, value)
        }
    }
    
    //MARK: - width
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина в виде вычисляемого `RZProtoValue`
    @discardableResult
    public func width(_ value: RZUIValue) -> Self{
        uiUpdate(priority: .high, tag: .width, value: value) { view, value in
            Self._width(view, value)
        }
    }
    
    static func _height(_ view: UIView, _ value: CGFloat){
        view.frame.size.height = value
    }
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина
    @discardableResult
    public func height(_ value: CGFloat) -> Self{
        uiUpdate(tag: .height, value: value) { view, value in
            Self._height(view, value)
        }
    }
    
    //MARK: - width
    /// `RU: - `
    /// Устанавливает ширину view
    ///
    /// - Parameter value
    /// Устанавливаемая ширина в виде вычисляемого `RZProtoValue`
    @discardableResult
    public func height(_ value: RZUIValue) -> Self{
        uiUpdate(priority: .high, tag: .height, value: value) { view, value in
            Self._height(view, value)
        }
    }
}
