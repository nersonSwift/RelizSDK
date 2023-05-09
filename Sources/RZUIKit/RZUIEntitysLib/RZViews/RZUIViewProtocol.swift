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
    func model(_ closure: (inout V.Model) -> ()) -> Self{
        closure(&view.model)
        return self
    }
    
    @discardableResult
    func create() -> Self{
        view.create()
        return self
    }
}
