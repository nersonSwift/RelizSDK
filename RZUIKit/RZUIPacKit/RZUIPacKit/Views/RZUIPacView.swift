//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

class RZUIPacViewInterfase{
    weak var uiPacC: RZUIPacControllerNJProtocol?
}

public protocol RZUIPacViewNoJenericProtocol: UIView, RZControlledNJProtocol{
    func create()
    func rotate()
    func resize()
}

extension RZUIPacViewNoJenericProtocol{
    public func create() {}
    public func resize() {}
    public func rotate() {}
}

public typealias RZUIPacView = UIView & RZUIPacViewNoJenericProtocol & RZControlledProtocol
