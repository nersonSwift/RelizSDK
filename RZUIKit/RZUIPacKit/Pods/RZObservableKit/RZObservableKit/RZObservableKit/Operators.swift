//
//  Operators.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import Foundation

precedencegroup SecondTernaryPrecedence {
    associativity: right
}

precedencegroup FirstTernaryPrecedence {
    associativity: left
    higherThan: SecondTernaryPrecedence
}

infix operator ?> : SecondTernaryPrecedence
infix operator <| : FirstTernaryPrecedence
