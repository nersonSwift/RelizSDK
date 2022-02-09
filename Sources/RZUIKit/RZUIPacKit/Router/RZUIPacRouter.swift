//
//  Router.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI
import RZDependencyKit

public typealias RZUIPacRouter = RZUIPacRouterProtocol & ObservableObject

public protocol RZUIPacRouterNGProtocol {}
public protocol RZUIPacRouterProtocol: ObservableObject, RZDependencyProtocol, RZUIPacRouterNGProtocol{}
