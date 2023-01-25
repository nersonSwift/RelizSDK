//
//  RZVB+AddSubview.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 20.05.2022.
//

import Foundation

extension RZViewBuilder{
    @discardableResult
    public func addSubview(_ value: UIView) -> Self{
        view.addSubview(value)
        return self
    }
    @discardableResult
    public func addSubview(_ value: (UIView)->(UIView)) -> Self{
        addSubview(value(view))
    }
    @discardableResult
    public func addSubviews(_ value: [UIView]) -> Self{
        value.forEach{ addSubview($0) }
        return self
    }
    @discardableResult
    public func addSubviews(_ value: UIView...) -> Self{
        addSubviews(value)
    }
    
    @discardableResult
    public func addSubviews(@ArrayBuilder _ value: (UIView)->([UIView])) -> Self{
        addSubviews(value(view))
    }
}


