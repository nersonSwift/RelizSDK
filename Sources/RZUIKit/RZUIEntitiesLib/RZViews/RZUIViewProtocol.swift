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
    func create()
}

extension RZBuilder where V: RZUIViewProtocol{
    @discardableResult
    public func model(_ closure: (inout V.Model) -> ()) -> Self{
        closure(&view.model)
        return self
    }
    
    @discardableResult
    public func model(_ model: V.Model) -> Self{
        view.model = model
        return self
    }
    
    @discardableResult
    public func create() -> Self{
        view.create()
        return self
    }
}
