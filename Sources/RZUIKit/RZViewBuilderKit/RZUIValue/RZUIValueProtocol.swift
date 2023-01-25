//
//  RZUIValueProtocol.swift
//  RZViewBuilderKit
//
//  Created by Александр Сенин on 13.05.2022.
//

import UIKit
import RZObservableKit

public protocol RZUIValueProtocol{
    var value: RZObservable<CGFloat> { get }
}

extension RZUIValueProtocol {
    public var cgFloat: CGFloat { value.wrappedValue }
}

