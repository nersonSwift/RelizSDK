//
//  RZVB+isHidden.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    //MARK: - isHidden
    static func _isHidden(_ view: UIView, _ value: Bool){
        view.isHidden = value
    }
    @discardableResult
    public func isHidden(_ value: Bool) -> Self{
        uiUpdate(tag: .isHidden, value: value) { view, value in
            Self._isHidden(view, value)
        }
    }
    @discardableResult
    public func isHidden(_ value: RZObservable<Bool>?) -> Self{
        guard let value = value else {return self}
        return uiUpdate(tag: .isHidden, value: value) { view, value in
            Self._isHidden(view, value)
        }
    }
}
