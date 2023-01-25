//
//  RZVB+Alpha.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation
import RZObservableKit

extension RZViewBuilder{
    //MARK: - alpha
    static func _alpha(_ view: V, _ value: CGFloat){
        view.alpha = value
    }
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self{
        uiUpdate(tag: .alpha, value: value) { view, value in
            Self._alpha(view, value)
        }
    }
    @discardableResult
    public func alpha(_ value: RZObservable<CGFloat>?) -> Self{
        guard let value = value else { return self }
        return uiUpdate(tag: .alpha, value: value) { view, value in
            Self._alpha(view, value)
        }
    }
}
