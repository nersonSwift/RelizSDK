//
//  Operators.swift
//  RelizKit
//
//  Created by Александр Сенин on 17.10.2020.
//


//MARK: - RZViewBuilderKit
postfix operator +>
postfix operator *
postfix operator |*

infix operator <>
infix operator ><

precedencegroup SecondTernaryPrecedence {
    associativity: right
}

precedencegroup FirstTernaryPrecedence {
    associativity: left
    higherThan: SecondTernaryPrecedence
}

infix operator ?> : SecondTernaryPrecedence
infix operator <| : FirstTernaryPrecedence

//MARK: - RZDarkModeKit
infix operator <-

