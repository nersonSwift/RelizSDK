//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import RZObservableKit

extension RZObservable: RZProtoValueProtocol {
    public func getValue(_ view: UIView) -> CGFloat {
        switch wrappedValue {
        case let value as CGFloat:
            return value
        case let value as RZProtoValue:
            return value.getValue(view)
        default:
            return .zero
        }
    }
}
