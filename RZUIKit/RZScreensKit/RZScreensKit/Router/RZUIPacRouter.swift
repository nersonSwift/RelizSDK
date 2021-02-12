//
//  Router.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public typealias RZUIPacRouter = RZUIPacRouterProtocol & ObservableObject

public protocol RZUIPacRouterNJProtocol{}
public protocol RZUIPacRouterProtocol: ObservableObject, RZUIPacRouterNJProtocol{}

