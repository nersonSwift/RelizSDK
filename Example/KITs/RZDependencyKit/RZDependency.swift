//
//  RZDependency.swift
//  RZDependencyKit
//
//  Created by Александр Сенин on 09.02.2022.
//

import Foundation

public protocol RZRootDependentProtocol{}
extension RZRootDependentProtocol{
    fileprivate init(_ closure: ()->(Self)){ self = closure() }
}

public protocol RZAnyDependentProtocol: AnyObject, RZRootDependentProtocol {}
extension RZAnyDependentProtocol{
    public init<DP: RZDependencyProtocol>(anyDependency: DP, init: ()->(Self)){
        DP.dependency = anyDependency
        self.init(`init`)
        DP.dependency = nil
    }
}

public protocol RZDependentProtocol: RZAnyDependentProtocol {
    associatedtype Dependency: RZDependencyProtocol
    var dependency: Dependency { get set }
}
extension RZDependentProtocol{
    public init(_ dependency: Dependency, _ init: @autoclosure ()->(Self)){
        self.init(anyDependency: dependency, init: `init`)
    }
}

public protocol RZDependencyProtocol{ init() }
extension RZDependencyProtocol{
    private static var dependencyKey: String {"RZDependencyKey"}
    fileprivate static var dependency: Self? {
        set(value){ Thread.current.threadDictionary["dependencyKey"] = value }
        get{ Thread.current.threadDictionary["dependencyKey"] as? Self }
    }
    
    public static func setup(_ init: @autoclosure ()->(Self) = .init()) -> Self{
        if let dependency = dependency{
            self.dependency = nil
            return dependency
        }else{
            return `init`()
        }
    }
}

