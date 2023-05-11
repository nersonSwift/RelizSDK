//
//  File.swift
//  Example
//
//  Created by Александр Сенин on 09.05.2023.
//

import UIKit
import RZUIPacKit
import RZViewBuilderKit

public protocol RZUIViewProtocol: UIView{
    associatedtype Model: RZUIPacRouter
    var model: Model {get set}
    
    func initActions()
    func create()
}

extension RZUIViewProtocol{
    public func initActions() {}
}

extension RZBuilder where V: RZUIViewProtocol{
    @discardableResult
    public func setupModel(_ model: V.Model) -> Self{
        setupModel{ $0 = model }
    }
    
    @discardableResult
    public func setupModel(_ closure: (inout V.Model) -> ()) -> Self{
        closure(&view.model)
        return initActions()
    }
    
    @discardableResult
    public func initActions() -> Self{
        view.initActions()
        return self
    }
    
    @discardableResult
    public func model(_ closure: (V.Model) -> ()) -> Self{
        closure(view.model)
        return self
    }
    
    @discardableResult
    public func create() -> Self{
        view.create()
        return self
    }
}
