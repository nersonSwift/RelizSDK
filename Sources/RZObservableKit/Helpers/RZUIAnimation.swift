//
//  RZUIAnimation.swift
//  RZObservableKit
//
//  Created by Александр Сенин on 23.03.2021.
//

import UIKit

public struct RZUIAnimation {
    private var _duration: TimeInterval = 0
    private var _delay: TimeInterval = 0
    private var _dampingRatio: CGFloat = 0
    private var _velocity: CGFloat = 0
    private var _options: UIView.AnimationOptions = []
    
    private var rzoDuration: RZObservable<TimeInterval>?
    private var rzoDelay: RZObservable<TimeInterval>?
    private var rzoDampingRatio: RZObservable<CGFloat>?
    private var rzoVelocity: RZObservable<CGFloat>?
    private var rzoOptions: RZObservable<UIView.AnimationOptions>?
    
    public func duration(_ value: TimeInterval) -> Self {
        var animation = self
        animation._duration = value
        animation.rzoDuration = nil
        return animation
    }
    public func duration(_ value: RZObservable<TimeInterval>?) -> Self {
        var animation = self
        animation.rzoDuration = value
        return animation
    }
    
    public func delay(_ value: TimeInterval) -> Self {
        var animation = self
        animation._delay = value
        animation.rzoDelay = nil
        return animation
    }
    public func delay(_ value: RZObservable<TimeInterval>?) -> Self {
        var animation = self
        animation.rzoDelay = value
        return animation
    }
    
    public func options(_ value: UIView.AnimationOptions) -> Self {
        var animation = self
        animation._options = value
        animation.rzoOptions = nil
        return animation
    }
    public func options(_ value: RZObservable<UIView.AnimationOptions>?) -> Self {
        var animation = self
        animation.rzoOptions = value
        return animation
    }
    
    public func damping(_ dampingRatio: CGFloat, _ velocity: CGFloat) -> Self {
        var animation = self
        animation._dampingRatio = dampingRatio
        animation._velocity = velocity
        
        animation.rzoDampingRatio = nil
        animation.rzoVelocity = nil
        
        return animation
    }
    public func damping(_ dampingRatio: RZObservable<CGFloat>?, _ velocity: RZObservable<CGFloat>?) -> Self {
        var animation = self
        animation.rzoDampingRatio = dampingRatio
        animation.rzoVelocity = velocity
        return animation
    }
    
    public func animate(_ action: @escaping ()->(), _ completion: @escaping (Bool)->() = {_ in}){
        let usingSpringWithDamping = rzoDampingRatio?.wrappedValue ?? _dampingRatio
        let initialSpringVelocity = rzoVelocity?.wrappedValue ?? _velocity
        if usingSpringWithDamping == 0, initialSpringVelocity == 0{
            UIView.animate(
                withDuration: rzoDuration?.wrappedValue ?? _duration,
                delay: rzoDelay?.wrappedValue ?? _delay,
                options: rzoOptions?.wrappedValue ?? _options,
                animations: action,
                completion: completion
            )
        }else{
            UIView.animate(
                withDuration: rzoDuration?.wrappedValue ?? _duration,
                delay: rzoDelay?.wrappedValue ?? _delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: rzoOptions?.wrappedValue ?? _options,
                animations: action,
                completion: completion
            )
        }
    }
    
    
    public init(){}
}

extension RZUIAnimation{
    public static func duration(_ value: TimeInterval) -> Self { Self().duration(value) }
    public static func duration(_ value: RZObservable<TimeInterval>?) -> Self { Self().duration(value) }
    
    public static func delay(_ value: TimeInterval) -> Self { Self().delay(value) }
    public static func delay(_ value: RZObservable<TimeInterval>?) -> Self { Self().delay(value) }
    
    public static func options(_ value: UIView.AnimationOptions) -> Self { Self().options(value) }
    public static func options(_ value: RZObservable<UIView.AnimationOptions>?) -> Self { Self().options(value) }
    
    public static func damping(_ dampingRatio: CGFloat, _ velocity: CGFloat) -> Self { Self().damping(dampingRatio, velocity) }
    public static func damping(_ dampingRatio: RZObservable<CGFloat>?, _ velocity: RZObservable<CGFloat>?) -> Self { Self().damping(dampingRatio, velocity)
    }
    
    public static var standart: Self { Self.duration(0.3) }
    public static var ezDamping: Self { Self.duration(0.8).damping(0.8, 0.3).options(.curveEaseOut) }
    public static var slowEzOut: Self { Self.duration(2).options(.curveEaseOut) }
}
