//
//  Router.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public typealias RZRouter = RZRouterProtocol & ObservableObject

public protocol RZRouterNJProtocol: RZControlledNJProtocol{
    var rzViewType: RZAnyView.Type? { get }
}
public protocol RZRouterProtocol: RZRouterNJProtocol, RZControlledProtocol{}



