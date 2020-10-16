//
//  Router.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public typealias RZRouter = RZRowRouter & ObservableObject

protocol RZRouterProtocol: NSObject{
    var screenController: RZScreenControllerProtocol? { get set }
    var screenType: RZAnyScreen.Type? { get }
    init()
}


public class RZRowRouter: NSObject, RZRouterProtocol{
    weak var screenController: RZScreenControllerProtocol?
    var screenType: RZAnyScreen.Type? { nil }
    required override init() {super.init()}
}
