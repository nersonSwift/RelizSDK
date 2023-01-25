//
//  RZVBLabel+Text.swift
//  Example
//
//  Created by Александр Сенин on 06.06.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder where V: UILabel{
    //MARK: - text
    static func _text(_ view: V, _ value: String?){
        view.text = value
        RZLabelSizeController.modUpdate(view)
    }
    /// `RU: - `
    /// Устанавливает текст для UILabel
    ///
    /// - Parameter value
    /// Устанавливаемый текст
    @discardableResult
    public func text(_ value: String?) -> Self{
        uiUpdate(tag: .text, value: value) { view, value in
            Self._text(view, value)
        }
    }
    @discardableResult
    public func text(_ value: RZObservable<String?>?) -> Self{
        guard let value = value else { return self }
        return uiUpdate(tag: .text, value: value) { view, value in
            Self._text(view, value)
        }
    }
    @discardableResult
    public func text(_ value: RZObservable<String>?) -> Self{
        guard let value = value else { return self }
        return uiUpdate(tag: .text, value: value) { view, value in
            Self._text(view, value)
        }
    }
}
