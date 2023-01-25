//
//  RZVB+Color.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    public enum ColorType: String {
        case background = "cBackground"
        case content    = "cContent"
        case border     = "cBorder"
        case shadow     = "cShadow"
        case tint       = "cTint"
    }
    
    //MARK: - color
    static func _color(_ view: V, _ value: UIColor, _ type: ColorType = .background) {
        switch type {
            case .background: view <- { $0.backgroundColor = UIColor(cgColor: value.cgColor) }
            case .content: _setContentColor(view, value)
            case .border: view <- { $0.layer.borderColor = value.cgColor }
            case .shadow: view <- { $0.layer.shadowColor = value.cgColor }
            case .tint: view <- { $0.tintColor = UIColor(cgColor: value.cgColor) }
        }
    }
    static func _setContentColor(_ view: V, _ value: UIColor){
        switch view {
        case let label as UILabel:
            label <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let textView as UITextView:
            textView <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let textField as UITextField:
            textField <- { $0.textColor = UIColor(cgColor: value.cgColor) }
        case let button as UIButton:
            button <- { $0.setTitleColor(UIColor(cgColor: value.cgColor), for: .normal) }
        default:break
        }
    }
    /// `RU: - `
    /// Устанавливает цвет редактироемому view
    ///
    /// - Parameter value
    /// Устанавливаемый цвет при необходимости конвертирует цвет в `CGColor`
    ///
    /// Поддерживает адаптивные цвета RZDarkModeKit
    ///
    /// - Parameter type
    /// Тег мета установки цвета
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType...) -> Self {
        return color(value, type)
    }
    @discardableResult
    public func color(_ value: UIColor, _ type: [ColorType]) -> Self {
        type.forEach{ color(value, $0) }
        return self
    }
    
    @discardableResult
    public func color(_ value: UIColor, _ type: ColorType = .background) -> Self {
        uiUpdate(tag: .custom(type.rawValue), value: value) { view, color in
            Self._color(view, color, type)
        }
    }
    @discardableResult
    public func color(_ value: RZObservable<UIColor>?, _ type: ColorType = .background) -> Self{
        guard let value = value else { return self }
        uiUpdate(tag: .custom(type.rawValue), value: value) { view, color in
            Self._color(view, color, type)
        }
        return self
    }
}
