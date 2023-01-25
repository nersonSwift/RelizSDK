//
//  RZVB+CornerRadius.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit


extension RZViewBuilder{
    //MARK: - cornerRadius
    static func _cornerRadius(_ view: UIView, _ value: CGFloat){
        view.layer.cornerRadius = value
    }
    
    static func _cornerRadius(_ view: UIView, _ value: CGFloat, _ corners: UIRectCorner){
        view.layer.cornerRadius = 0
        view.roundCorners(corners, radius: value)
    }
    
    /// `RU: - `
    /// Устанавливает радиус скругления редактируемому view
    ///
    /// - Parameter value
    /// Радиус скругления
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self{
        uiUpdate(tag: .cornerRadius, value: value) { view, value in
            Self._cornerRadius(view, value)
        }
    }
    @discardableResult
    public func cornerRadius(_ value: RZUIValue) -> Self{
        uiUpdate(tag: .cornerRadius, value: value) { view, value in
            Self._cornerRadius(view, value)
        }
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat, _ corners: UIRectCorner) -> Self{
        uiUpdate(tag: .cornerRadius, value: value) { view, value in
            Self._cornerRadius(view, value, corners)
        }
    }
    
    @discardableResult
    public func cornerRadius(_ value: RZUIValue, _ corners: UIRectCorner) -> Self{
        uiUpdate(tag: .cornerRadius, value: value) { view, value in
            Self._cornerRadius(view, value, corners)
        }
    }
}
